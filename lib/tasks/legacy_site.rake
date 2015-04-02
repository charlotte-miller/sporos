require 'net/ssh/gateway'
Dir[Rails.root.join("lib/legacy_adapters/**/*.rb")].each {|f| require f}

namespace "legacy_site" do

  desc "Migrates Pages from the Legacy Site"
  task "pages" => 'environment' do    
    auth_key = ENV['LEGACY_ACCESS_KEY'] || File.read(Rails.root.join('config/legacy_access/sporos'))
    gateway = Net::SSH::Gateway.new( '173.230.153.98', 'cornerstonesf', key_data: auth_key)
    gateway.open('127.0.0.1', 5432, 9000)
    fork do
      LegacyPage.db_setup send("cornerstone_sf_org_#{Rails.env}"), 'simple_cms_navigation'
      LegacyPage.update_or_create_recent_pages
      Page.audit_urls
    end
    
    Process.wait
    gateway.shutdown!
  end


  desc "Migrates Media from the Legacy Site"
  task "media" => 'environment' do
    LegacyChannel.db_setup  send("cornerstone_sf_org_#{Rails.env}"),  'tv_channel'
    LegacySeries.db_setup   send("cornerstone_sf_org_#{Rails.env}"),  'tv_series'
    LegacyMedia.db_setup    send("cornerstone_sf_org_#{Rails.env}"),   'tv_mediaitem'

    [LegacyChannel, LegacySeries, LegacyMedia].each(&:update_all)
  end
end

def cornerstone_sf_org_production
  { adapter: 'postgresql',
    encoding: 'unicode',
    pool: 5,
    database: 'cornerstone-sf-org',
    host: '127.0.0.1',
    port: 9000,
    username: 'sporos',
    password: '86HKW?kXj6U+A%LPkP2QeDfJ7@&M=9', }
end

def cornerstone_sf_org_development
  'cornerstone_sf_org_development'
end