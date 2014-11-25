# == Schema Information
#
# Table name: lessons
#
#  id                      :integer          not null, primary key
#  study_id                :integer          not null
#  position                :integer          default("0")
#  title                   :string(255)      not null
#  description             :text(65535)
#  author                  :string(255)
#  backlink                :string(255)
#  poster_img_file_name    :string(255)
#  poster_img_content_type :string(255)
#  poster_img_file_size    :integer
#  poster_img_updated_at   :datetime
#  poster_img_original_url :string(255)
#  poster_img_fingerprint  :string(255)
#  video_file_name         :string(255)
#  video_content_type      :string(255)
#  video_file_size         :integer
#  video_updated_at        :datetime
#  video_original_url      :string(255)
#  video_fingerprint       :string(255)
#  audio_file_name         :string(255)
#  audio_content_type      :string(255)
#  audio_file_size         :integer
#  audio_updated_at        :datetime
#  audio_original_url      :string(255)
#  audio_fingerprint       :string(255)
#  machine_sorted          :boolean          default("0")
#  duration                :integer
#  published_at            :datetime
#  created_at              :datetime
#  updated_at              :datetime
#
# Indexes
#
#  index_lessons_on_backlink               (backlink)
#  index_lessons_on_study_id_and_position  (study_id,position)
#

require 'rails_helper'
require 'cocaine'
require 'spec/models/lesson/adapters/web_sites/dummy_klass'

describe Lesson do
  it { is_expected.to belong_to( :study )}
  it { is_expected.to have_many( :questions )}
  # it { is_expected.to delegate_method(:title).to(:study).with_prefix }
  it { is_expected.to validate_presence_of :study }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :author }
  
  it "builds from factory", :internal do
    lambda { create(:lesson) }.should_not raise_error
  end
  
  it "touches the associated Study on update", :internal do
    study = create(:study_w_lesson)
    expect_any_instance_of(Study).to receive(:touch).once
    study.lessons.first.touch
  end
    
  describe '[scopes]'do
    describe 'for_study(:study_id)' do
      it "adds WHERE(study_id=n)" do
        Lesson.for_study(1).to_sql.should match /WHERE `lessons`.`study_id` = 1/
      end
    end
  end

  describe '.new_from_adapter(lesson_adapter)' do
    subject { Lesson.new_from_adapter(adapter) }
    
    context "w/ Lesson::Adapters::Podcast -" do
      let(:podcast_xml) { File.read(File.join(Rails.root, 'spec/files/podcast_xml', 'itunes.xml')) }
      let(:podcast_item) { Podcast::Channel.new(podcast_xml).items.first }
      let(:adapter) { Lesson::Adapters::Podcast.new(podcast_item) }
      
      it "builds a @lesson from an adapter" do
        should be_a Lesson
        subject.study = Study.new
        should be_valid
      end

      it "requires a study sepratly" do
        subject.valid?
        subject.errors.messages.should eq( :study => ["can't be blank"] )
      end
    end
    
    context "w/ Lesson::Adapters::Web -" do
      vcr_lesson_web
      let(:url) { @url || 'http://www.something.com' }
      let(:nokogiri_doc) { Nokogiri::HTML(open url) }
      let(:adapter) { Lesson::Adapters::Web.new(url, nokogiri_doc) }
      
      it "builds a @lesson from an adapter" do
        should be_a Lesson
        subject.study = Study.new
        should be_valid
      end

      it "requires a study sepratly" do
        subject.valid?
        subject.errors.messages.should eq( :study => ["can't be blank"] )
      end
    end
  end
  
  describe '#belongs_with?( other_lesson )' do
    subject { build_stubbed(:lesson) }
    let(:other_lesson) { build_stubbed(:lesson) }
    before(:each) do
      Lesson::SimilarityHeuristic::Base::STRATEGIES.each {|strategy| strategy.any_instance.stub(matches?:false) } #all stragegies 'off'
    end
    
    it "returns TRUE if any of the Lesson::SimilarityHeuristic#matches?" do
      Lesson::SimilarityHeuristic::Base::STRATEGIES.last.any_instance.stub(matches?:true)
      expect( subject.belongs_with?( other_lesson ) ).to be true
    end
    
    it "returns FALSE if NONE of the Lesson::SimilarityHeuristic#matches?" do
      expect( subject.belongs_with?( other_lesson ) ).to be false
    end
  end
  
  describe '#duplicate?' do
    it "matches on backlink" do
      a, b = 2.times.map { build(:lesson, backlink:'foo') }
      a.save
      b.should be_duplicate
    end
  end
end