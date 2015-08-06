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
#  display_options     :jsonb            default("{}"), not null
#  poster_file_name    :string
#  poster_content_type :string
#  poster_file_size    :integer
#  poster_updated_at   :datetime
#  poster_original_url :string
#  rejected_at         :datetime
#  published_at        :datetime
#  expired_at          :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  featured_at         :datetime
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
  # include Commentable - moved to ApprovalRequest

  # ---------------------------------------------------------------------------------
  # Scopes
  # ---------------------------------------------------------------------------------
  # default_scope ->{ order('updated_at DESC')}

  # Single Table Inheritance
  scope :events,      -> { where(type: 'Posts::Event')    }
  scope :link,        -> { where(type: 'Posts::Link')     }
  scope :page,        -> { where(type: 'Posts::Page')     }
  scope :photo,       -> { where(type: 'Posts::Photo')    }
  scope :video,       -> { where(type: 'Posts::Video')    }
  scope :w_out_pages, -> { where("type != 'Posts::Page'")}

  scope :pre_release, -> { where( 'published_at IS NULL') }
  scope :published,   -> { where( 'published_at IS NOT NULL') }
  scope :current,     -> { published.where('(NOW() <= COALESCE(expired_at, NOW()))')} #'(NOW() BETWEEN published_at AND expired_at)'
  scope :expired,     -> { where( 'expired_at IS NOT NULL AND NOW() > expired_at') }
  scope :evergreen,   -> { where( 'expired_at IS NULL') }

  scope :featured_order, ->{ order('featured_at is null') }
  scope :relevance_order, ->{ order('ABS(EXTRACT(EPOCH FROM (NOW() - COALESCE(expired_at, published_at)))) ASC')}

  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------
  belongs_to :ministry
  belongs_to :author, class_name:'User', foreign_key: :user_id

  has_many :approval_requests, dependent: :destroy
  has_many :approvers, through:'approval_requests', source: :user

  has_one :draft, :class_name => "Post", :foreign_key => "parent_id"

  has_many :comment_threads, through: :approval_requests

  has_many :uploaded_files, as:'from', dependent: :destroy

  has_one :comm_arts_request, dependent: :destroy
    accepts_nested_attributes_for :comm_arts_request, reject_if: :attributes_absent

  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------
  validates_presence_of :type, :user_id, :ministry_id, :title
  validates_presence_of :expired_at, if: -> (obj){obj.type=='Post::Event'}
  validates_associated :ministry, :author, on:'create'


  # ---------------------------------------------------------------------------------
  # Attributes
  # ---------------------------------------------------------------------------------
  delegate :file, to: :uploaded_files
  has_public_id :public_id, prefix:'post', length:21
  def to_param; public_id || generate_missing_public_id ;end

  attr_protected #none - using strong params
  attr_accessor :unread_comment_count, :current_session
  has_attachable_file :poster, {
                      :default_url   => :poster_original_url,
                      :content_type  => ["image/jpg", "image/jpeg", "image/png", "image/gif"],
                      # production_path: 'posts/:post_id/poster/:hash:quiet_style.:extension',
                      :processors => [:thumbnail, :paperclip_optimizer],
                      paperclip_optimizer: { jhead:true, jpegrecompress:true, jpegtran:true },
                      :styles => {
                        large:        { geometry: "1500x1500>", format: 'jpg', convert_options: "-strip" },
                        medium:       { geometry: "500x500>",   format: 'jpg', convert_options: "-strip" },
                        small:        { geometry: "200x200>",   format: 'jpg', convert_options: "-strip" },
                        large_thumb:  { geometry: "120x120#",   format: 'jpg', convert_options: "-strip" },
                        thumb:        { geometry: "100x100#",   format: 'jpg', convert_options: "-strip" }
                      }}

  process_in_background :poster, processing_image_url: :poster_original_url

  def display_options
    DeepStruct.new super
  end

  def poster_original_url
    super || '' #FIXES PAPERCLIP BUG
  end

  def poster_url
    poster.try(:url)
  end

  def file_urls(style=:original)
    uploaded_files.map {|uf| uf.file.url(style) }
  end

  # ---------------------------------------------------------------------------------
  # Callbacks
  # ---------------------------------------------------------------------------------

  after_create :find_uploaded_files_by_session, :request_approval!

  def request_approval!
    if find_approvers.present?
      find_approvers.map do |user|
        ApprovalRequest.create!( post_id:id, user_id:user.id )
      end
    else
      if author.involvements.in_ministry(ministry).first.editor?
        self.touch :published_at # Editors publish instantly
      end
    end
    ApprovalRequest.create!( post_id:id, user_id:author.id, status:'accepted' ) # Everyone accepts their own work
  end


  def find_approvers #=> Users
    @find_approvers ||= begin
      involvement = Involvement.where(user_id:user_id, ministry_id:ministry_id).first
      involvement.more_involved_in_this_ministry
      # filter from UI
    end
  end

  # after_create :find_uploaded_files_by_session  #MUST run before request_approval!
  def find_uploaded_files_by_session
    UploadedFile.where(session_id:current_session).each do |file|
      file.from = self
      file.session_id = nil
      file.save
    end
  end


  # ---------------------------------------------------------------------------------
  # Methods
  # ---------------------------------------------------------------------------------
  def status
    return 'rejected'  if rejected_at
    return 'pending'   if !published_at
    return 'published' if published_at && (expired_at.nil? || expired_at > Time.now)
    return 'archived'  if expired_at < Time.now
  end


  def as_json(options={})
    def files
      uploaded_files.map {|uf| uf.file.url}
    end

    super(options.merge({
      only: [ :type, :public_id, :ministry_id, :title, :description, :published_at, :expired_at ],
      methods:[ :poster_url, :files]
    }))
  end

  private

  def attributes_absent(attributed)
    requested_work = %w{design_purpose design_tone design_cta notes postcard_quantity poster_quantity booklet_quantity badges_quantity}.find do |attr|
      attributed[attr].present?
    end
    !requested_work
  end

end
