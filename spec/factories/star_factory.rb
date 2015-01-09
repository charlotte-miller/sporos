# == Schema Information
#
# Table name: stars
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  source_id   :integer          not null
#  source_type :string(50)       not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_stars_on_source_id_and_source_type  (source_id,source_type)
#  index_stars_on_user_id                    (user_id)
#

FactoryGirl.define do
  factory :star do
    user
    source ""
  end
end
