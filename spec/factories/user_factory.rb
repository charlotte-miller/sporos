# == Schema Information
#
# Table name: users
#
#  id                         :integer          not null, primary key
#  first_name                 :string(60)
#  last_name                  :string(60)
#  public_id                  :string(20)
#  email                      :string(80)       default(""), not null
#  encrypted_password         :string(255)      default(""), not null
#  password_salt              :string(255)
#  reset_password_token       :string(255)
#  reset_password_sent_at     :datetime
#  remember_created_at        :datetime
#  sign_in_count              :integer          default("0")
#  current_sign_in_at         :datetime
#  last_sign_in_at            :datetime
#  current_sign_in_ip         :string(255)
#  last_sign_in_ip            :string(255)
#  confirmation_token         :string(255)
#  confirmed_at               :datetime
#  confirmation_sent_at       :datetime
#  unconfirmed_email          :string(255)
#  failed_attempts            :integer          default("0")
#  locked_at                  :datetime
#  profile_image_file_name    :string(255)
#  profile_image_content_type :string(255)
#  profile_image_file_size    :integer
#  profile_image_updated_at   :datetime
#  profile_image_fingerprint  :string(255)
#  created_at                 :datetime
#  updated_at                 :datetime
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_public_id             (public_id) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :user, aliases: [:requester, :author, :member] do
    before(:create, :stub) do
      AWS.stub! if Rails.env.test?
    end
    
    first_name  'Fred'
    last_name   'Fredrickson'
    sequence(   :email)  {|n| "example@domain#{n}.com"}
    password    'super-secret'
    password_confirmation  {|me| me.password }
    profile_image { fixture_file_upload(Rails.root.join('spec/files/', 'user_profile_image.jpg'), 'image/jpg', true) }
  end
end