# == Schema Information
#
# Table name: simple_cms_navigation
#
#  id                 :integer          not null, primary key
#  created_at         :datetime         default("2012-01-02 09:07:10.959543+00"), not null
#  updated_at         :datetime         default("2012-01-02 09:07:10.959832+00"), not null
#  active             :boolean          default("true"), not null
#  title              :string(255)      not null
#  slug               :string(50)       not null
#  group_id           :integer
#  parent_id          :integer
#  order              :integer          default("-1"), not null
#  homepage           :boolean          default("false"), not null
#  url                :string(255)      default(""), not null
#  target             :string(255)      default(""), not null
#  page_title         :string(255)      default(""), not null
#  text               :text             default(""), not null
#  format             :string(255)      default(""), not null
#  render_as_template :boolean          default("false"), not null
#  template           :string(255)      default(""), not null
#  view               :string(255)      default(""), not null
#  inherit_blocks     :boolean          default("true"), not null
#  site_id            :integer          not null
#  redirect_url       :string(255)      not null
#  redirect_permanent :boolean          not null
#  inherit_template   :boolean          not null
#
# Indexes
#
#  simple_cms_navigation_group_id                       (group_id)
#  simple_cms_navigation_parent_id                      (parent_id)
#  simple_cms_navigation_site_id                        (site_id)
#  simple_cms_navigation_site_id_56c69c465376e2e1_uniq  (site_id,parent_id,slug) UNIQUE
#  simple_cms_navigation_slug                           (slug)
#  simple_cms_navigation_slug_like                      (slug)
#

require 'mixins/external_table'

class LegacyPage < ActiveRecord::Base
  include ExternalTable
  
  belongs_to :parent, :class_name => "LegacyPage", :foreign_key => "parent_id"
  
  def self.update_or_create_recent_pages(only_updates=false)
    find_recent_updates(only_updates).map(&:update_or_create_page).length
    #remove pages that have been flagged inactive
  end
    
  def update_or_create_page
    page = Page.friendly.find(slug)
    parent_id         = find_or_create_parent.try(:id)
    page.title        = title
    page.body         = html_text
    page.seo_keywords = []
    page.hidden_link  = hidden_link?
    page.save! if page.changed?
    page
    
  rescue ActiveRecord::RecordNotFound
    page = Page.create!({
      parent_id: find_or_create_parent.try(:id),
      title: title,
      body:  html_text,
      seo_keywords: [],
      hidden_link: hidden_link?
    })
    page.update_attribute(:slug, slug) if page.slug != slug #force at create
    page
  end

private #----------------------------------------------------------------------------
  
  def self.find_recent_updates(only_updates)
    last_updated_page   = Page.maximum(:updated_at) if only_updates
    last_updated_page ||= Time.at(0)
    LegacyPage
      .order('parent_id DESC') #parents first
      .where(['updated_at > ?', last_updated_page])
      .where(active:true)
      .where(homepage:false)
      .where("text!=''")
      .all
  end
  
  
  def find_or_create_parent
    legacy_parent = self.parent
    modern_parent = legacy_parent.try(:update_or_create_page)
  end

  def html_text
    if format=='markdown'
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
      markdown.render text
    else
      text
    end
  end
  
  def hidden_link?
    parent_id.nil? && group_id.nil?
  end
  
end
