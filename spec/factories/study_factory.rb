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

require 'rspec/mocks/standalone'
include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :study do
    ignore do
      lesson nil    # create an associated @lesson 
      slug   false  # override the generated slug
      last_published_at nil
    end
          
    podcast
    channel
    lessons     { [lesson].compact }
    title       { Faker::Lorem.sentence(rand(3..8))  }
    description { Faker::Lorem.paragraph(rand(2..5)) }
    ref_link    "http://link.com/salt-and-light"
    poster_img  { fixture_file_upload(Rails.root.join('spec/files/', 'poster_image.jpg'), 'image/jpg', true) }
    poster_img_original_url 'http://example.com/poster_image.jpg'
    
    before(:create, :stub) { AWS.stub! if Rails.env.test? }
    after(:create, :stub) do |study, context|
      stubbing = context.instance_variable_get('@build_strategy').is_a? FactoryGirl::Strategy::Stub
      new_slug = context.slug
      new_last_published_at = context.last_published_at
      
      # assign and save proteced attributes (non mass_assigned)
      study.stub(touch:true)                          if stubbing
      study.slug              = new_slug              if new_slug
      study.last_published_at = new_last_published_at if new_last_published_at
      study.save! if !stubbing && (new_slug || new_last_published_at)
    end
  end
  
  # creates a study w/ a single lesson
  factory :study_w_lesson, parent: 'study' do
    lesson {FactoryGirl.create(:lesson, study:build_stubbed(:study) )}
    after(:create) {|study| study.reload }
  end
  
  # creates a study w/ 'n' number of assocaiated lessons
  factory :study_w_lessons, aliases:[:study_with_n_lessons], parent: 'study' do
    ignore  { n 2 }
    lessons { n.times.map {FactoryGirl.create(:lesson, study:build_stubbed(:study) )} }
    after(:create) {|study| study.reload }
  end
end
