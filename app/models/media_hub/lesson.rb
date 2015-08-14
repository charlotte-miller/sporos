# == Schema Information
#
# Table name: lessons
#
#  id                      :integer          not null, primary key
#  study_id                :integer          not null
#  position                :integer          default("0")
#  title                   :string           not null
#  description             :text
#  author                  :string
#  backlink                :string
#  poster_img_file_name    :string
#  poster_img_content_type :string
#  poster_img_file_size    :integer
#  poster_img_updated_at   :datetime
#  poster_img_original_url :string
#  poster_img_fingerprint  :string
#  poster_img_processing   :boolean
#  video_vimeo_id          :string
#  video_file_name         :string
#  video_content_type      :string
#  video_file_size         :integer
#  video_updated_at        :datetime
#  video_original_url      :string
#  video_fingerprint       :string
#  video_processing        :boolean
#  audio_file_name         :string
#  audio_content_type      :string
#  audio_file_size         :integer
#  audio_updated_at        :datetime
#  audio_original_url      :string
#  audio_fingerprint       :string
#  audio_processing        :boolean
#  machine_sorted          :boolean          default("false")
#  duration                :integer
#  published_at            :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  handout_file_name       :string
#  handout_content_type    :string
#  handout_file_size       :integer
#  handout_updated_at      :datetime
#  handout_original_url    :text
#  handout_fingerprint     :text
#  handout_processing      :boolean
#
# Indexes
#
#  index_lessons_on_backlink               (backlink)
#  index_lessons_on_study_id_and_position  (study_id,position)
#  index_lessons_on_video_vimeo_id         (video_vimeo_id) UNIQUE
#

class Lesson < ActiveRecord::Base
  include Sortable
  include Sanitizable
  include Questionable
  include Lesson::AttachedMedia
  include Lesson::Search

  # ---------------------------------------------------------------------------------
  # Attributes
  # ---------------------------------------------------------------------------------
  # http://norman.github.io/friendly_id/file.Guide.html#Slugged_Models
  # extend FriendlyId
  # friendly_id :position, :use => :scoped, :scope => :study

  delegate :title, :to => :study, prefix:true  # study_title
  acts_as_listable scope: :study

  # Private 'sudo' access to everything
  attr_accessible *column_names, :study, :audio_remote_url, :video_remote_url, :poster_img, :poster_img_remote_url, as: 'sudo'

  # Public
  attr_accessible :study, :study_id, :position, :title, :author, :description, :backlink, :published_at, :machine_sorted,
                  :audio, :video, :poster_img, :audio_remote_url, :video_remote_url, :poster_img_remote_url, :handout_remote_url,
                  :video_vimeo_id


  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------
  belongs_to :study, touch:true, class_name:'Study'  # counter_cache rolled into Study#touch
  # has_one :poster_maker, :class_name => "Lesson::PosterMaker", :dependent => :destroy
  has_many :user_lesson_states


  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------
  validates_presence_of :study, :title, :author
  # validates_uniqueness_of :position, :scope => :study_id
  # validates_attachment_presence :audio, :video

  # http://stackoverflow.com/questions/3181845/validate-attachment-content-type-paperclip
  # validates_attachment_content_type :video, :audio


  # ---------------------------------------------------------------------------------
  # Callbacks
  # ---------------------------------------------------------------------------------
  before_save :process_poster_img_first # Lesson::AttachedMedia
  before_save :video_vimeo_id_from_original_url

  # ---------------------------------------------------------------------------------
  # Scopes
  # ---------------------------------------------------------------------------------
  # default_scope order: 'position ASC'
  scope :for_study, lambda {|study_id| where({ study_id: study_id }) }


  # ---------------------------------------------------------------------------------
  # Methods
  # ---------------------------------------------------------------------------------
  class << self

    # Builds a lesson from an instance of Lesson::Adapters::'Klass'
    # WARN Study must be added later
    def new_from_adapter(lesson_adapter)
      new(lesson_adapter.to_hash, as:'sudo')
    end
  end

  # Determins how similar a lesson is to the other_lesson
  # Loops through an array of heuristics looking for a match (stops after match)
  # => returns true|false
  #
  def belongs_with? other_lesson
    require 'media_hub/lesson/similarity_heuristic/base'
    !!Lesson::SimilarityHeuristic::Base::STRATEGIES.find do |strategy|
      strategy.new(self, other_lesson).matches?
    end
  end

  def duplicate?
    Lesson.where(backlink: backlink).exists?
  end

  def show_url
    url_helpers.study_lesson_url(study, self)
  end

private

  def video_vimeo_id_from_original_url
    return unless video_original_url_changed? && video_original_url =~ /vimeo.com/
    self.video_vimeo_id = video_original_url.match(/vimeo.com\/(\d+)/)[1]
  end
end


# Support the namespacing convention for rake tasks etc.
MediaHub::Lesson = Lesson
