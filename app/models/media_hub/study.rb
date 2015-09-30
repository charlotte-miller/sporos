# == Schema Information
#
# Table name: studies
#
#  id                      :integer          not null, primary key
#  slug                    :string           not null
#  channel_id              :integer          not null
#  podcast_id              :integer
#  position                :integer          not null
#  title                   :string           not null
#  description             :text
#  keywords                :text             default("{}"), is an Array
#  ref_link                :string
#  poster_img_file_name    :string
#  poster_img_content_type :string
#  poster_img_file_size    :integer
#  poster_img_updated_at   :datetime
#  poster_img_original_url :string
#  poster_img_fingerprint  :string
#  poster_img_processing   :boolean
#  lessons_count           :integer          default("0")
#  last_published_at       :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_studies_on_last_published_at                 (last_published_at)
#  index_studies_on_podcast_id_and_last_published_at  (podcast_id,last_published_at)
#  index_studies_on_slug                              (slug) UNIQUE
#

class Study < ActiveRecord::Base
  include Sortable
  include Sluggable
  include Sanitizable
  include AttachableFile
  # include Study::Search

  TEACHING_CHANNELS = %w{ messages studies resources mens-retreat coffeetalk }
  MUSIC_CHANNELS    = %w{ music }
  ARTS_CHANNELS     = %w{ dramavideo }

  # ---------------------------------------------------------------------------------
  # Attributes
  # ---------------------------------------------------------------------------------
  attr_accessible :title, :description, :ref_link,  :poster_img, :poster_img_remote_url, :podcast, :podcast_id
  attr_accessible *column_names, *reflections.keys, :poster_img, :poster_img_remote_url, :podcast, :podcast_id, as: 'sudo'
  delegate :church_name, to: :podcast

  acts_as_listable scope: :channel

  slug_candidates :title, [:title, :year], [:title, :month, :year], [:title, :month, :date, :year]

  has_attachable_file :poster_img,
                      :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"],
                      :processors => [:thumbnail, :paperclip_optimizer],
                      paperclip_optimizer: { jhead:true, jpegrecompress:true, jpegtran:true },
                      :styles => {
                        large:        { geometry: "1500x1500>", format: 'jpg', convert_options: "-strip" },
                        medium:       { geometry: "500x500>",   format: 'jpg', convert_options: "-strip" },
                        small:        { geometry: "200x200>",   format: 'jpg', convert_options: "-strip" },
                        large_thumb:  { geometry: "120x120#",   format: 'jpg', convert_options: "-strip" },
                        thumb:        { geometry: "100x100#",   format: 'jpg', convert_options: "-strip" }
                      }

  process_in_background :poster_img


  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------
  belongs_to :channel
  belongs_to :podcast, :inverse_of => :studies
  has_one :church,     :through => :podcast, :inverse_of => :studies
  has_many :lessons, -> {order 'lessons.position ASC'}, {:dependent => :destroy, class_name:'Lesson'}# do
  #   def number(n, strict=false)
  #     raise ActiveRecord::RecordNotFound if strict && (n > self.length) #lessons_count
  #     where(position:n).first
  #   end
  # end
  has_many :groups


  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------
  validates_presence_of :slug, :title, :channel
  # validates_uniqueness_of :title, :scope => :podcast_id


  # ---------------------------------------------------------------------------------
  # Callbacks
  # ---------------------------------------------------------------------------------
  before_validation :add_default_values


  # ---------------------------------------------------------------------------------
  # Scopes
  # ---------------------------------------------------------------------------------
  scope :teaching, -> { where(channel_id: Channel.where(slug:TEACHING_CHANNELS).pluck(:id)) }
  scope :music,    -> { where(channel_id: Channel.where(slug:MUSIC_CHANNELS).pluck(:id)) }
  scope :arts,     -> { where(channel_id: Channel.where(slug:ARTS_CHANNELS).pluck(:id)) }
  scope :w_lessons, -> {includes(:lessons)}


  # ---------------------------------------------------------------------------------
  # Methods
  # ---------------------------------------------------------------------------------
  class << self
    def new_from_podcast_channel(podcast_channel, attribute_overrides={})
      new({
        title:                  podcast_channel.title,
        description:            podcast_channel.description,
        ref_link:               podcast_channel.homepage,
        poster_img_remote_url:  podcast_channel.poster_img,
        last_published_at:      podcast_channel.last_updated,
      }.merge(attribute_overrides), as: 'sudo')
    end
  end


  # Answers "Is this lesson part of this study?"
  def include?(lesson)
    raise ArgumentError.new('Study#include? requires a @lesson') unless lesson.is_a? Lesson
    lessons.include? lesson
  end

  # Determins if a lesson SHOULD part of this study
  # => false if lessons.empty?
  def should_include?(lesson)
    raise ArgumentError.new('Study#include? requires a @lesson') unless lesson.is_a? Lesson
    !!(lessons.last.try :belongs_with?, lesson)
  end

  # Single lesson study
  def stand_alone?
    lessons.size == 1 #lessons_count
  end

  # Replace original http://apidock.com/rails/ActiveRecord/Persistence/touch
  def touch(*names)
    self.lessons_count     = lessons.length
    self.last_published_at = lessons.map(&:published_at).max
    self.updated_at        = Time.now
    self.save!
  end

  def organization
    # future association
  end

  def tags
    # future association
  end

  def authors
    if lessons.loaded?
      lessons.map(&:author)
    else
      lessons.pluck(:author)
    end.uniq.join(', ')
  end

  private #--------------------------------------------------------------------------------

  def add_default_values
    self.channel_id || self.channel ||= Channel.first
  end
end

# Support the namespacing convention for rake tasks etc.
MediaHub::Study = Study
