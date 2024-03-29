# == Schema Information
#
# Table name: users
#
#  id                         :integer          not null, primary key
#  first_name                 :string(60)
#  last_name                  :string(60)
#  public_id                  :string(20)
#  email                      :string(80)       default(""), not null
#  encrypted_password         :string           default("")
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
#  invitation_token           :string
#  invitation_created_at      :datetime
#  invitation_sent_at         :datetime
#  invitation_accepted_at     :datetime
#  invitation_limit           :integer
#  invited_by_id              :integer
#  invited_by_type            :string
#  invitations_count          :integer          default("0")
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invitations_count     (invitations_count)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_public_id             (public_id) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

require 'rails_helper'

describe User do
  subject { build(:user) }

  it "builds from factory", :internal do
    expect { create(:user) }.to_not raise_error
  end

  it_behaves_like 'it has_public_id', {prefix:'MEM', length:20}

  it { should have_many(:group_memberships) }
  it { should have_many(:groups) }
  it { should have_many(:block_requests) }
  it { should have_many(:involvements) }
  it { should have_many(:approval_requests) }
  it { should have_many(:posts) }
  it { should have_many(:ministries) }
  it { should have_many(:user_lesson_states) }

  it { should validate_presence_of(:email) }
  it { should ensure_length_of(:email).is_at_most(80) }
  it { should ensure_length_of(:first_name).is_at_most(60) }
  it { should ensure_length_of(:last_name).is_at_most(60) }
  it "validates :email format" do
    should allow_value('chip@mail.com').for(:email)
    ['chip.com', 'chip@mail', 'chipmail'].each do |bad_value|
      should_not allow_value(bad_value).for(:email)
    end
  end

  describe 'mass_assignment' do
    describe 'blocks protected attributes' do
      [:id, :encrypted_password, :password_salt, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :failed_attempts, :locked_at, :encrypted_password].each do |attr|
        it "- #{attr}" do
          should_not allow_mass_assignment_of(attr)
        end
      end
    end

    describe 'allows public attributes' do
      [:email, :first_name, :last_name, :password, :password_confirmation, :remember_me, :profile_image].each do |attr|
        it "- #{attr}" do
          should allow_mass_assignment_of(attr)
        end
      end
    end
  end

  describe '#name' do
    it "should combine first_name and last_name" do
      build_stubbed(:user, first_name:'Billy', last_name:'Bob').name.should eql 'Billy Bob'
    end
  end

  describe '#membership_in(group)' do
    before(:each) do
      @membership_1, @membership_2 = memberships = 2.times.map { create(:group_membership, member:subject ) }
      @group_1, @group_2 = memberships.map(&:group)
    end

    it "finds a single group " do
      membership = subject.membership_in(@group_1)
      membership.should be_a GroupMembership
    end

    it "finds the correct GroupMembership" do
      subject.membership_in(@group_1).should eql @membership_1
      subject.membership_in(@group_2).should eql @membership_2
    end
  end
end

