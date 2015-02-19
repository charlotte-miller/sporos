require 'rails_helper'
require Rails.root.join('lib/paperclip_processors/upload_to_vimeo')

module Paperclip
  describe UploadToVimeo do
    subject { UploadToVimeo.new(nil) }
    let(:run_make){ subject.make }
    let(:result)  { run_make }

    it { should be_kind_of( ::Paperclip::Processor) }
    
    describe '#make' do
      vcr_vimeo_upload
      
      it 'uploads to vimeo' do
        
      end
      
      it 'gets a vimeo id' do
        
      end
      
      it 'updates remote_url with the vimeo url' do
        
      end
    end
  end
end