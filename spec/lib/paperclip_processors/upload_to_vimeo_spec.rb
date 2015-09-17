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
        expect_any_instance_of(VimeoUploadApi).to_not receive(:upload_to_vimeo!)
        # expect(subject).to_not receive(:generate_vimeo_ticket!)
        lesson.video_remote_url = 'https://vimeo.com/45678'
        run_make
      end

      it 'uploads to vimeo' do
        run_make
        response = Typhoeus.get("https://api.vimeo.com/videos/#{subject.bypass.vimeo_api.video_vimeo_id}", headers: {"Authorization" => "bearer #{AppConfig.vimeo.token}"})
        expect(response.code).to eq(200)
        video_data = DeepStruct.from_json response.body
        expect(video_data.name).to eq(lesson.title)
        expect(video_data.description).to eq(lesson.description)
      end

      it 'stores the video_vimeo_id' do
        run_make
        expect(lesson.video_vimeo_id).not_to be_nil
        expect(lesson.video_vimeo_id).to eq(subject.bypass.vimeo_api.video_vimeo_id)
      end

      it 'leaves video_original_url for reference' do
        run_make
        expect(lesson.video_original_url).to eq('http://foo.com/bar')
        # ^ Tests an edge case where the link was stored in an attr_accessor
      end
    end
  end
end
