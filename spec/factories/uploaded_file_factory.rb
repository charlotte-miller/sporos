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

FactoryGirl.define do
  before(:create, :stub) do
    AWS.stub! if Rails.env.test?
  end

  factory :uploaded_file do
    ignore do
      w_video false
    end

    from { FactoryGirl.create(:post_photo) }
    session_id { rand(1_000_000).to_s }
    image { !w_video ? fixture_file_upload(Rails.root.join('spec/files/', 'user_profile_image.jpg'), 'image/jpg', true) : nil }
    video { w_video  ? fixture_file_upload(Rails.root.join('spec/files/', 'video.m4v'), 'video/mp4', true) : nil }
  end

end
