# == Schema Information
#
# Table name: comm_arts_requests
#
#  id                    :integer          not null, primary key
#  post_id               :integer
#  design_requested      :boolean
#  design_creative_brief :jsonb            default("{}"), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  due_date              :datetime
#  archived_at           :datetime
#  todo                  :jsonb
#  print_quantity        :jsonb
#
# Indexes
#
#  index_comm_arts_requests_on_archived_at  (archived_at)
#  index_comm_arts_requests_on_post_id      (post_id)
#

require 'rails_helper'

RSpec.describe CommArtsRequest, :type => :model do
  
  it "builds from factory", :internal do
    expect { create(:comm_arts_request) }.to_not raise_error
  end
  
  describe 'design_purpose setters' do
    it 'creates setter methods for :design_purpose, :design_tone, :design_cta' do
      [:design_purpose, :design_tone, :design_cta].each do |virtual_attr|
        subject.send("#{virtual_attr}=", 'blark')
        expect(subject.send(virtual_attr)).to eq('blark')
      end
    end
  end
end
