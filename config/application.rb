require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require 'elasticsearch/rails/instrumentation'
# require 'elasticsearch/rails/lograge'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
# Precompile assets before deploying to production
Bundler.require(*Rails.groups(:assets => %w(development test)))

module Sporos
  class Application < Rails::Application
    require File.expand_path('../initializers/_configy', __FILE__)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Pacific Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :en

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Custom directories with classes and modules you want to be autoloadable.
    config.paths.add "#{Rails.root}/lib/mixins",           eager_load:true
    config.paths.add "#{Rails.root}/app/models/content",   eager_load:true
    config.paths.add "#{Rails.root}/app/models/media_hub", eager_load:true

    # Be sure to have the adapter's gem in your Gemfile and follow
    # the adapter's specific installation and deployment instructions.
    config.active_job.queue_adapter = :resque

    config.react.addons = true

    # Generate Controllers w/out associated styles/scripts
    config.generators do |g|
      g.assets = false
      # g.helper false
      # g.template_engine false
    end

    config.cache_store = :redis_store, "#{AppConfig.redis.url}/0/cache", { expires_in: 1.week }

    config.assets.enabled = true
    config.assets.initialize_on_precompile = false

    config.assets.precompile += %w{ vendor.js admin.js admin.css}
    config.assets.precompile += ['groups/*.js', 'page_initializers/*.js','community/posts/all.js']
    config.assets.precompile += ['library/*.js']


    config.assets.image_optim = {
      pack:true,    skip_missing_workers: true,
      pngout:false, svgo: false,
    }

    # String should use VARCHAR not VARCHAR(255)
    initializer "postgresql.no_default_string_limit" do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::ConnectionAdapters::PostgreSQLAdapter::NATIVE_DATABASE_TYPES[:string].delete(:limit)
      end
    end
  end
end
