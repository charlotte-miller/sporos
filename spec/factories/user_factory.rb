# == Schema Information
#
# Table name: users
#
#  id                         :integer          not null, primary key
#  first_name                 :string(60)
#  last_name                  :string(60)
#  public_id                  :string(20)
#  email                      :string(80)       default(""), not null
#  encrypted_password         :string           default(""), not null
#  admin                      :boolean          default("false")
#  password_salt              :string
#  reset_password_token       :string
#  reset_password_sent_at     :datetime
#  remember_created_at        :datetime
#  sign_in_count              :integer          default("0")
#  current_sign_in_at         :datetime
#  last_sign_in_at            :datetime
#  current_sign_in_ip         :string
#  last_sign_in_ip            :string
#  confirmation_token         :string
#  confirmed_at               :datetime
#  confirmation_sent_at       :datetime
#  unconfirmed_email          :string
#  failed_attempts            :integer          default("0")
#  locked_at                  :datetime
#  unlock_token               :string
#  profile_image_file_name    :string
#  profile_image_content_type :string
#  profile_image_file_size    :integer
#  profile_image_updated_at   :datetime
#  profile_image_fingerprint  :string
#  profile_image_processing   :boolean
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_public_id             (public_id) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :user, aliases: [:requester, :author, :member] do
    before(:create, :stub) do
      AWS.stub! if Rails.env.test?
    end
    
    admin       false
    first_name  {Faker::Name.first_name}
    last_name   {Faker::Name.last_name}
    sequence(   :email)  {|n| "example@domain#{n}.com"}
    password    'super-secret'
    password_confirmation  {|me| me.password }
    profile_image { fixture_file_upload(Rails.root.join('spec/files/', 'user_profile_image.jpg'), 'image/jpg', true) }
  end
  
  factory :admin_user, parent:'user', aliases: [:approver, :permanent_approver] do
    admin true
  end
end
