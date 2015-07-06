# == Schema Information
#
# Table name: comm_arts_requests
#
#  id                    :integer          not null, primary key
#  post_id               :integer
#  design_requested      :boolean
#  design_creative_brief :jsonb            default("{}"), not null
#  print_postcard        :boolean
#  print_poster          :boolean
#  print_booklet         :boolean
#  print_badges          :boolean
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_comm_arts_requests_on_post_id  (post_id)
#

class CommArtsRequest < ActiveRecord::Base
  belongs_to :post
  has_one :ministry, through: :post
  
  delegate_attrs_to_jsonb :design_purpose, :design_tone, :design_cta, to: :design_creative_brief
  attr_protected #none

end
