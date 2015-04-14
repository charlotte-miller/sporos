# == Schema Information
#
# Table name: approval_requests
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  post_id    :integer          not null
#  status     :integer          default("0"), not null
#  notes      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_approval_requests_on_post_id              (post_id)
#  index_approval_requests_on_user_id_and_post_id  (user_id,post_id) UNIQUE
#  index_approval_requests_on_user_id_and_status   (user_id,status)
#

require 'rails_helper'

RSpec.describe ApprovalRequest, :type => :model do
  subject { build(:approval_request) }

  it "builds from factory", :internal do
    expect { create(:approval_request) }.to_not raise_error
  end
  
  it { should belong_to(:post) }
  it { should belong_to(:user) }
end
