require 'rails_helper'
Dir[Rails.root.join("lib/paperclip_processors/**/*.rb")].each {|f| require f}

describe Lesson::AttachedMedia do
  subject { build(:lesson) }
  let(:paperclip_worker) { DelayedPaperclip::Jobs::Resque }
  
  it { is_expected.to respond_to :audio }
  it { is_expected.to respond_to :video }
  it { is_expected.to respond_to :poster_img }
  
  describe 'attached poster_img -' do
    it "runs the :thumbnail processor", pending:'Future video processing' do
      expect_any_instance_of(Paperclip::Thumbnail).to receive(:make).at_least(:once).and_return(img_file)
      subject.poster_img = img_file
      subject.poster_img.process_delayed!
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