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

class Content::Page < ActiveRecord::Base
  include Sluggable
  slug_candidates :title, [:title, :year], [:title, :month, :year]
  
  validates :title, presence:true, length:{in:2..150}
  validates :body,  presence:true, length:{maximum:500_000}
end
