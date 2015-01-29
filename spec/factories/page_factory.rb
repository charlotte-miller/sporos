# == Schema Information
#
# Table name: pages
#
#  id           :integer          not null, primary key
#  parent_id    :integer
#  slug         :string           not null
#  title        :string           not null
#  body         :text             not null
#  seo_keywords :text             default("{}"), not null, is an Array
#  hidden_link  :boolean          default("false"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_pages_on_slug  (slug) UNIQUE
#

FactoryGirl.define do
  factory :page do
    title { Faker::Lorem.sentence(rand(3..6))  }
    body { Faker::Lorem.paragraph(rand(2..5)) }
    seo_keywords ["men", "guys", "fellas"]
  end

end
