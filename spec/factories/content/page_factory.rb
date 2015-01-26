# == Schema Information
#
# Table name: content_pages
#
#  id           :integer          not null, primary key
#  slug         :string           not null
#  title        :string           not null
#  body         :text             not null
#  seo_keywords :text             default("{}"), not null, is an Array
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_content_pages_on_slug  (slug) UNIQUE
#

FactoryGirl.define do
  factory :page, :class => 'Content::Page', aliases:['content_page'] do
    title "Men's Ministry"
    body "A ministry for Men"
    seo_keywords ["men", "guys", "fellas"]
  end

end
