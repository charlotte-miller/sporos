require 'rails_helper'
Dir[Rails.root.join("lib/paperclip_processors/**/*.rb")].each {|f| require f}

describe Lesson::AttachedMedia do #, :focus
  subject { build(:lesson) }
  
  it { is_expected.to respond_to :audio }
  it { is_expected.to respond_to :video }
  it { is_expected.to respond_to :poster_img }
      
  describe 'attached audio -' do
    it "runs the :video_to_audio processor" do
      expect_any_instance_of(Paperclip::VideoToAudio).to receive(:make).at_least(:once).and_return(audio_file)
      subject.audio = audio_file
    end
  end
  
  describe 'attached video -' do
    it "runs the :audio_to_video processor" do
      expect_any_instance_of(Paperclip::AudioToVideo).to receive(:make).at_least(:once).and_return(video_file)
      subject.video = video_file
    end
    
    it "runs the :ffmpeg processor" do
      expect_any_instance_of(Paperclip::Ffmpeg).to receive(:make).at_least(:once).and_return(video_file)
      subject.video = video_file
    end
    
    it "runs the :qtfaststart processor" do
      expect_any_instance_of(Paperclip::Qtfaststart).to receive(:make).at_least(:once).and_return(video_file)
      subject.video = video_file
    end
  end
  
  describe 'attached poster_img -' do
    it "runs the :thumbnail processor" do
      expect_any_instance_of(Paperclip::Thumbnail).to receive(:make).at_least(:once).and_return(img_file)
      subject.poster_img = img_file
    end
    
    it "runs the :pngquant processor" do
      skip 'TODO'
      PngQuant.should_receive(:new)
    end  
    
    it "is processed first (the audio_to_video processor requires :poster_img)" do
      subject.instance_variable_set(:@attachments_for_processing, [:foo, :poster_img, :bar, :baz])
      subject.save!
      subject.instance_variable_get(:@attachments_for_processing).should eql [:poster_img, :foo, :bar, :baz]
    end  
  end
  
  describe '#poster_img_w_study_backfill' do
    subject { create(:lesson, poster_img:@img) }
    
    it "returns Lesson#poster_img if avalible" do
      @img = img_file
      subject.poster_img_w_study_backfill.instance.should be_kind_of Lesson
    end
    
    it "returns Study#poster_img if Lesson#poster_img is not set" do
      @img = nil
      subject.poster_img_w_study_backfill.instance.should be_kind_of Study
    end
  end
end