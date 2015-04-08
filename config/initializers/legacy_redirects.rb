# Support Legacy Redirects
require 'rack-slashenforce'
require Rails.root.join('lib/middleware/legacy_redirects')

m = Rails.application.config.middleware
m.insert 0, Rack::Rewrite, { klass: Rack::Rewrite::LegacyRedirects, options:{} }
m.insert_before Rack::Rewrite, Rack::RemoveTrailingSlashes