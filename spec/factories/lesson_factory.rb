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

include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :lesson do
    before(:create, :stub) { AWS.stub! if Rails.env.test? }

    study
    # position 1
    title       { Faker::Lorem.sentence(rand(3..6))  }
    description { Faker::Lorem.paragraph(rand(2..5)) }
    author      { Faker::Name.name }
    backlink    "http://link.com/salt-and-light"
    poster_img  { fixture_file_upload(Rails.root.join('spec/files/', 'poster_image.jpg'), 'image/jpg', true) }
    video       { fixture_file_upload(Rails.root.join('spec/files/', 'video.m4v'       ), 'video/mp4', true) }
    audio       { fixture_file_upload(Rails.root.join('spec/files/', 'audio.m4a'       ), 'audio/mp4', true) }
    video_original_url 'http://example.com/video.m4v'
    audio_original_url 'http://example.com/audio.m4a'
    published_at Time.now
  end
end
