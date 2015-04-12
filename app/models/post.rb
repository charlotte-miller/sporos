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
#  expires_at          :datetime         not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_posts_on_ministry_id  (ministry_id)
#  index_posts_on_parent_id    (parent_id)
#  index_posts_on_type         (type)
#  index_posts_on_user_id      (user_id)
#

class Post < ActiveRecord::Base
  include Sanitizable
  include AttachableFile

  # ---------------------------------------------------------------------------------
  # Single Table Inheritance
  # ---------------------------------------------------------------------------------  
  scope :events,  -> { where(type: 'Post::Event') }
  scope :link,    -> { where(type: 'Post::Link')  }
  scope :page,    -> { where(type: 'Post::Page')  }
  scope :photo,   -> { where(type: 'Post::Photo') }
  scope :video,   -> { where(type: 'Post::Video') }


  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------  
  belongs_to :ministry
  belongs_to :author, class_name:'User', foreign_key: :user_id
  
  has_many :approval_requests
  has_one :draft, :class_name => "Post", :foreign_key => "parent_id"
  
  
  # ---------------------------------------------------------------------------------
  # Attributes
  # ---------------------------------------------------------------------------------
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
    # Scopes
    # ---------------------------------------------------------------------------------
    default_scope ->{ where('published_at IS NOT NULL') }
    

    # ---------------------------------------------------------------------------------
    # Callbacks
    # ---------------------------------------------------------------------------------
    
    after_create :request_approval!

    def request_approval!
      author_level = author
        .ministry_involvements
        .where( ministry:ministry )
        .first.try(:level).try(:to_i)
      
      more_involved_users = Involvement
        .where( ministry:ministry )
        .where(['level > ?', author_level])
        .map(&:user)
      
      more_involved_users.each do |user|
        ApprovalRequest.create({
          post:self,
          user_id:user
        })
      end
    end
    
    def update_status!
      votes                 = approval_requests.decided
      results               = votes.map(&:status).uniq
      supporting_districts  = votes.where(status: :accepted).map(&:level).uniq.length
      required_districts    = 4 - (author.level+1) # Leader, Admin
      
      if is_rejected  = results.include?(:rejected)
        # send rejection notice
        
      elsif is_accepted  = results.include?(:accepted) && required_districts <= supporting_districts
        touch :published_at
        approval_requests.update_all('status = 3')
      else
        # do nothing... no votes
      end
    end
end
