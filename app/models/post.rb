# == Schema Information
#
# Table name: posts
#
#  id                  :integer          not null, primary key
#  parent_id           :integer
#  type                :text             not null
#  ministry_id         :integer          not null
#  user_id             :integer          not null
#  title               :text             not null
#  description         :text
#  display_options     :hstore
#  poster_file_name    :string
#  poster_content_type :string
#  poster_file_size    :integer
#  poster_updated_at   :datetime
#  published_at        :datetime
#  expired_at          :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_posts_on_expired_at   (expired_at)
#  index_posts_on_ministry_id  (ministry_id)
#  index_posts_on_parent_id    (parent_id)
#  index_posts_on_type         (type)
#  index_posts_on_user_id      (user_id)
#

class Post < ActiveRecord::Base
  include Sanitizable
  include AttachableFile

  # ---------------------------------------------------------------------------------
  # Scopes
  # ---------------------------------------------------------------------------------  
  default_scope ->{ order('expired_at DESC')}
  
  # Single Table Inheritance
  scope :events,  -> { where(type: 'Post::Event') }
  scope :link,    -> { where(type: 'Post::Link')  }
  scope :page,    -> { where(type: 'Post::Page')  }
  scope :photo,   -> { where(type: 'Post::Photo') }
  scope :video,   -> { where(type: 'Post::Video') }
  
  scope :pre_release, -> { where( 'published_at IS NULL') }
  scope :current,     -> { where( '(published_at IS NOT NULL) AND (expired_at IS NOT NULL) AND (NOW() BETWEEN published_at AND expired_at)' )}
  scope :expired,     -> { where( 'expired_at IS NOT NULL AND NOW() > expired_at') }
  scope :evergreen,   -> { where( 'expired_at IS NULL') }
  scope :published,   -> { where( 'published_at IS NOT NULL') }
  
  
  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------  
  belongs_to :ministry
  belongs_to :author, class_name:'User', foreign_key: :user_id
  
  has_many :approval_requests, dependent: :destroy
  has_many :approvers, class_name: "User", through:'approval_requests'
  
  has_one :draft, :class_name => "Post", :foreign_key => "parent_id"


  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------  
  validates_presence_of :type, :user_id, :ministry_id, :title
  validates_presence_of :expired_at, unless: -> (obj){obj.type=='Post::Page'} #evergreen
  validates_associated :ministry, :author, on:'create'
  
  
  # ---------------------------------------------------------------------------------
  # Attributes
  # ---------------------------------------------------------------------------------
  attr_protected #none - using strong params
  attr_accessor :approvers
  has_attachable_file :poster, {
                      # :processors      => [:thumbnail, :pngquant],
                      :default_style => :sd,
                      :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"],
                      # production_path: 'studies/lesson_media/:study_id/:hash:quiet_style.:extension',
                      :styles => {
                        sd:     { format: 'png', convert_options: "-strip" },
                        hd:     { format: 'png', convert_options: "-strip" },
                        mobile: { format: 'png', convert_options: "-strip" }}}


  # ---------------------------------------------------------------------------------
  # Callbacks
  # ---------------------------------------------------------------------------------
  
  after_create :request_approval!

  def request_approval!
    if find_approvers.present?
       find_approvers.map do |user|
        ApprovalRequest.create!( post_id:id, user_id:user.id )
      end
    else
      if author.involvements.in_ministry(ministry).first.editor?
        # Editors publish instantly
        self.touch :published_at
      end
    end
  end
  
  
  def find_approvers #=> Users
    @find_approvers ||= begin
      involvement = Involvement.where(user_id:user_id, ministry_id:ministry_id).first
      involvement.more_involved_in_this_ministry
    
      # filter from UI
    end
  end
end
