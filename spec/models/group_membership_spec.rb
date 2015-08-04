# == Schema Information
#
# Table name: group_memberships
#
#  id              :integer          not null, primary key
#  group_id        :integer          not null
#  user_id         :integer          not null
#  is_public       :boolean          default("true")
#  role_level      :integer          default("0")
#  state           :string           default("pending"), not null
#  request_sent_at :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_group_memberships_on_group_id_and_user_id   (group_id,user_id) UNIQUE
#  index_group_memberships_on_state                  (state)
#  index_group_memberships_on_user_id_and_is_public  (user_id,is_public)
#

require 'rails_helper'

describe GroupMembership do
  it { should belong_to( :member ).class_name( 'User' )}
  it { should belong_to :group }

  it "validate_uniqueness_of(:group_id).scoped_to(:user_id)" do
    create(:group_membership) # shoulda-hack: create a valid record for comparison
    should validate_uniqueness_of(:group_id).scoped_to(:user_id)
  end

  it "builds from factory", :internal do
    lambda { create(:group_membership) }.should_not raise_error
  end


  describe 'a public membership' do
    it "cannot be public if the group is private" do
      @group = create(:group,   is_public: false)
      create(:group_membership, is_public:true, group:@group).reload.is_public.should be false #validation error
    end

    it ".is_public scope filters by is_public " do
      GroupMembership.is_public.to_sql.should match(/.?is_public.? = 't'/)
    end
  end

  describe '#last_attended_at' do
    subject { create :group_membership }

    it "should alias updated_at" do
      Timecop.freeze('12/12/2012') {  subject.touch }
      subject.last_attended_at.should eql Time.parse('12/12/2012')
    end

  end
end
