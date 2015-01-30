# == Schema Information
#
# Table name: channels
#
#  id         :integer          not null, primary key
#  position   :integer          not null
#  title      :string           not null
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_channels_on_position  (position)
#  index_channels_on_slug      (slug) UNIQUE
#

FactoryGirl.define do
  factory :channel do
    title { Faker::Lorem.sentence(rand(3..6))  }
  end

end
