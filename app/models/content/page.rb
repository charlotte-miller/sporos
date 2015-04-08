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

class Page < ActiveRecord::Base
  include Sanitizable
  include Sluggable
  include Page::Search
  include Page::LegacyIntegration
  
  # ---------------------------------------------------------------------------------
  # Attributes
  # ---------------------------------------------------------------------------------
  slug_candidates :title, [:title, :year], [:title, :month, :year]

  
  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------
  belongs_to :parent, :class_name => "Page", :foreign_key => "parent_id"
  

  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------
  validates :title, presence:true, length:{in:2..150}
  validates :body,  presence:true, length:{maximum:500_000}
  
  
  # ---------------------------------------------------------------------------------
  # Methods
  # ---------------------------------------------------------------------------------
  
  def url
    url_helpers.page_url(self)
  end

  def path
    url_helpers.page_path(self)
  end
  
  def body_w_media
    body.gsub("{{ MEDIA_URL }}", AppConfig.domains.media)
  end
  
end

# Support the namespacing convention for rake tasks etc.
Content::Page = Page