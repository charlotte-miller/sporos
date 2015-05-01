# == Schema Information
#
# Table name: posts
#
#  id                  :integer          not null, primary key
#  type                :text             not null
#  public_id           :string(21)       not null
#  parent_id           :integer
#  ministry_id         :integer          not null
#  user_id             :integer          not null
#  title               :text             not null
#  description         :text
#  display_options     :hstore
#  poster_file_name    :string
#  poster_content_type :string
#  poster_file_size    :integer
#  poster_updated_at   :datetime
#  rejected_at         :datetime
#  published_at        :datetime
#  expired_at          :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_posts_on_ministry_id  (ministry_id)
#  index_posts_on_parent_id    (parent_id)
#  index_posts_on_public_id    (public_id) UNIQUE
#  index_posts_on_type         (type)
#  index_posts_on_user_id      (user_id)
#

class Post < ActiveRecord::Base
  include Sanitizable
  include AttachableFile
  include Uuidable

  # ---------------------------------------------------------------------------------
  # Scopes
  # ---------------------------------------------------------------------------------  
  # default_scope ->{ order('updated_at DESC')}
  
  # Single Table Inheritance
  scope :events,      -> { where(type: 'Post::Event')    }
  scope :link,        -> { where(type: 'Post::Link')     }
  scope :page,        -> { where(type: 'Post::Page')     }
  scope :photo,       -> { where(type: 'Post::Photo')    }
  scope :video,       -> { where(type: 'Post::Video')    }
  scope :w_out_pages, -> { where("type != 'Posts::Page'")}
  
  scope :pre_release, -> { where( 'published_at IS NULL') }
  scope :published,   -> { where( 'published_at IS NOT NULL') }
  scope :current,     -> { published.where('(NOW() <= COALESCE(expired_at, NOW()))')} #'(NOW() BETWEEN published_at AND expired_at)'
  scope :expired,     -> { where( 'expired_at IS NOT NULL AND NOW() > expired_at') }
  scope :evergreen,   -> { where( 'expired_at IS NULL') }
  
  scope :relevance_order, ->{ order('ABS(EXTRACT(EPOCH FROM (NOW() - COALESCE(expired_at, published_at)))) ASC')}
  
  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------  
  belongs_to :ministry
  belongs_to :author, class_name:'User', foreign_key: :user_id
  
  has_many :approval_requests, dependent: :destroy
  has_many :approvers, class_name: "User", through:'approval_requests'
  
  has_one :draft, :class_name => "Post", :foreign_key => "parent_id"
  
  has_many :comment_threads, through: :approval_requests

  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------  
  validates_presence_of :type, :user_id, :ministry_id, :title
  validates_presence_of :expired_at, if: -> (obj){obj.type=='Post::Event'}
  validates_associated :ministry, :author, on:'create'
  
  
  # ---------------------------------------------------------------------------------
  # Attributes
  # ---------------------------------------------------------------------------------
  has_public_id :public_id, prefix:'post', length:21
  def to_param; public_id ;end
  
  attr_protected #none - using strong params
  attr_accessor :approvers, :unread_comment_count
  has_attachable_file :poster, {
                      # :processors      => [:thumbnail, :pngquant],
                      :default_style => :sd,
                      :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"],
                      # production_path: 'studies/lesson_media/:study_id/:hash:quiet_style.:extension',
                      :styles => {
                        sd:     { format: 'png', convert_options: "-strip" },
                        hd:     { format: 'png', convert_options: "-strip" },
                        mobile: { format: 'png', convert_options: "-strip" }}}

  def display_options
    DeepStruct.new super
  end

  # ---------------------------------------------------------------------------------
  # Callbacks
  # ---------------------------------------------------------------------------------
  
  after_create :request_approval!

  def request_approval!
    if find_approvers.present?
      find_approvers.map do |user|
        ApprovalRequest.create!( post_id:id, user_id:user.id )
      end
      ApprovalRequest.create!( post_id:id, user_id:author.id, status:'accepted' )
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
  
  # ---------------------------------------------------------------------------------
  # Methods
  # ---------------------------------------------------------------------------------
  def status
    return 'rejected'  if rejected_at
    return 'pending'   if !published_at
    return 'published' if published_at && expired_at > Time.now
    return 'archived'  if expired_at < Time.now
  end
  
end
