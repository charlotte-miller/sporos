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

require 'rails_helper'

RSpec.describe Content::Page, :type => :model do
  it "builds from factory", :internal do
    lambda { create(:page) }.should_not raise_error
  end
  
  
end
