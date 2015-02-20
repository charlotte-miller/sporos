require 'rails_helper'
require Rails.root.join('lib/paperclip_processors/upload_to_vimeo')

module Paperclip
  describe UploadToVimeo do
    vcr_vimeo_upload

    subject { UploadToVimeo.new(video_file, {}, lesson.video) }
    let(:lesson) { create(:lesson, {
      title: 'Message of Wonders',
      description: 'Message of wonders is a very important message.',
      video_original_url:'http://foo.com/bar'}) }
    let(:run_make){ subject.make }
    let(:result)  { run_make }

    it { should be_kind_of( ::Paperclip::Processor) }
    
    describe '#make' do
      it 'ignores videos that are already in Vimeo' do
        expect(subject).to_not receive(:generate_vimeo_ticket!)
        lesson.video_remote_url = 'https://vimeo.com/45678'
        run_make
      end
      
      it 'uploads to vimeo' do
        run_make
        response = Typhoeus.get("https://api.vimeo.com/videos/#{subject.vimeo_video_id}", headers: {"Authorization" => "bearer #{AppConfig.vimeo.token}"})
        expect(response.code).to eq(200)
        video_data = DeepStruct.from_json response.body
        expect(video_data.name).to eq(lesson.title)
        expect(video_data.description).to eq(lesson.description)
      end
      
      it 'gets a vimeo id' do
        run_make
        expect(subject.vimeo_video_id).not_to be_nil
      end
      
      it 'updates remote_url with the vimeo url' do
        run_make
        expect(lesson.video_original_url).to eq("https://vimeo.com/#{subject.vimeo_video_id}")
      end
    end
  end
end