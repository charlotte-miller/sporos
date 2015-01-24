require 'net/ssh/gateway'
require "#{Rails.root}/lib/legacy_adapters/legacy_page"

namespace "legacy_site" do
  
  task "pages" => 'environment' do    
    auth_key = ENV['LEGACY_ACCESS_KEY'] || File.read(Rails.root.join('config/legacy_access/sporos'))
    gateway = Net::SSH::Gateway.new( '173.230.153.98', 'cornerstonesf', key_data: auth_key)
    gateway.open('127.0.0.1', 5432, 9000)
    fork do
      LegacyPage.db_setup "cornerstone_sf_org", 'simple_cms_navigation'
      LegacyPage.update_or_create_recent_pages
      Content::Page.audit_urls
    end
    
    Process.wait
    gateway.shutdown!
  end
  
end

