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

FactoryGirl.define do
  factory :comm_arts_request do
    post
    print false
    design false
    design_requested false
    design_creative_brief "{}"
    print_postcard false
    print_poster false
    print_booklet false
    print_badges false
  end

end
