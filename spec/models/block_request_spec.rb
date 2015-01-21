# == Schema Information
#
# Table name: block_requests
#
#  id            :integer          not null, primary key
#  admin_user_id :integer
#  user_id       :integer          not null
#  source_id     :integer          not null
#  source_type   :string(50)       not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_block_requests_on_source_id_and_source_type  (source_id,source_type)
#  index_block_requests_on_user_id                    (user_id)
#

require 'rails_helper'

describe BlockRequest do
  
  it { should belong_to( :requester ).class_name('User')    }
  it { should belong_to( :approver ).class_name('AdminUser')}
  it { should belong_to :source }
  
end
