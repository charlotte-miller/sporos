# == Schema Information
#
# Table name: admin_users
#
#  id                     :integer          not null, primary key
#  first_name             :string(60)
#  last_name              :string(60)
#  user_id                :integer
#  email                  :string(80)       default(""), not null
#  encrypted_password     :string           default(""), not null
#  password_salt          :string
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  sign_in_count          :integer          default("0")
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default("0")
#  unlock_token           :string
#  locked_at              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_admin_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_admin_users_on_email                 (email) UNIQUE
#  index_admin_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_admin_users_on_unlock_token          (unlock_token) UNIQUE
#

require 'rails_helper'

describe AdminUser do
  it "builds from factory", :internal do
    lambda { create(:admin_user) }.should_not raise_error
  end
  
  it { should delegate_method(:name).to(:user) }
  it { should delegate_method(:first_name).to(:user) }
  it { should delegate_method(:last_name).to(:user) }
  it { should delegate_method(:profile_image).to(:user) }
end
