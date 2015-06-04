require 'rails_helper'

describe Paperclip::Attachment do
  let(:normal) { create(:lesson) }
  let(:trusted_third_party) { create(:lesson, video:nil, video_remote_url:'https://www.youtube.com/watch?v=0JR6xt9S02o&t=3') }
  let(:non_trusted_third_party) { create(:lesson, video:nil, video_remote_url:'https://www.foo.com/watch?v=0JR6xt9S02o&t=3') }
  let(:empty) { create(:lesson, video:nil, video_original_url:nil) }
  
  describe '#url' do
    it "returns the S3 url when present?" do
      with_resque do
        expect(normal.reload.video.url('foo')).to match %r{http://#{AppConfig.domains.assets}/test/lessons/\d+/videos/foo.m4v}
      end
    end
    
    it "returns the instance.original_url if trusted_third_party?" do
      expect(trusted_third_party.video.url(:foo)).to eq 'https://www.youtube.com/watch?v=0JR6xt9S02o&t=3'
    end
    
    it "returns the 'missing' url otherwise" do
      expect(non_trusted_third_party.video.url(:foo)).to eq '/videos/foo/missing.png'
      expect(empty.video.url(:foo)).to eq '/videos/foo/missing.png'
    end
  end
  
  describe '#trusted_third_party?' do
    it "returns true only when <attachment>_original_url is trusted" do
      expect(normal.video.trusted_third_party?).to be false
      expect(empty.video.trusted_third_party?).to be false
      expect(non_trusted_third_party.video.trusted_third_party?).to be false
      expect(trusted_third_party.video.trusted_third_party?).to be true
    end
  end
  
end