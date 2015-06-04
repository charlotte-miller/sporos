# == Schema Information
#
# Table name: uploaded_files
#
#  id                 :integer          not null, primary key
#  from_id            :integer
#  from_type          :text
#  session_id         :text
#  image_file_name    :string
#  image_content_type :string
#  image_file_size    :integer
#  image_updated_at   :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  video_file_name    :string
#  video_content_type :string
#  video_file_size    :integer
#  video_updated_at   :datetime
#
# Indexes
#
#  index_uploaded_files_on_from_id_and_from_type  (from_id,from_type)
#  index_uploaded_files_on_session_id             (session_id)
#

require 'rails_helper'

RSpec.describe UploadedFile, :type => :model do
  subject { build_stubbed :uploaded_file }
  
  it "builds from factory", :internal do
    expect(lambda { create(:uploaded_file) }).not_to raise_error
  end
  
  it { should belong_to(:from)}
  
  describe '#file' do
    it 'returns the image if avalable' do
      expect(subject.file).to eq(subject.image)
    end
    
    it 'returns the video if image is unavalable' do
      subject = build_stubbed( :uploaded_file, w_video:true)
      expect(subject.file).to eq(subject.video)
    end
  end
  
  describe '#file_as_json' do
    it 'raises an ArgumentError if no file has been assigned' do
      subject = build(:uploaded_file, image:nil)
      expect(lambda {subject.file_as_json}).to raise_error ArgumentError
    end
    
    it 'returns a url, thumbnail_url, and delete_url' do
      as_json = subject.file_as_json
      [:url, :thumbnail_url, :delete_url].each do |key|
        expect(as_json[key]).to be_present
      end
    end
  end
end
