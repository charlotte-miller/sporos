require 'net/ssh/gateway'
Dir[Rails.root.join("lib/legacy_adapters/**/*.rb")].each {|f| require f}

namespace "legacy_site" do

  desc "Migrates Pages from the Legacy Site"
  task "pages" => 'environment' do    
    auth_key = ENV['LEGACY_ACCESS_KEY'] || File.read(Rails.root.join('config/legacy_access/sporos'))
    gateway = Net::SSH::Gateway.new( '173.230.153.98', 'cornerstonesf', key_data: auth_key)
    gateway.open('127.0.0.1', 5432, 9000)
    fork do
      LegacyPage.db_setup "cornerstone_sf_org_#{Rails.env}", 'simple_cms_navigation'
      LegacyPage.update_or_create_recent_pages
      Page.audit_urls
    end
    
    Process.wait
    gateway.shutdown!
  end


  desc "Migrates Media from the Legacy Site"
  task "media" => 'environment' do
    LegacyChannel.db_setup "cornerstone_sf_org_#{Rails.env}", 'tv_channel'
    LegacySeries.db_setup "cornerstone_sf_org_#{Rails.env}", 'tv_series'
    LegacyMedia.db_setup "cornerstone_sf_org_#{Rails.env}", 'tv_mediaitem'

    [LegacyChannel, LegacySeries].each(&:update_all) #, LegacyMedia
  end
end

