Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries    = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Surpress asset call logs like:
  # Started GET "/assets/application.js" for 127.0.0.1 at 2015-01-28 13:35:34 +0300
  # Served asset /application.js - 304 Not Modified (8ms)
  config.quiet_assets = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # config.web_console.automount = true
  # config.web_console.default_mount_path = '/terminal' # Optional, defaults to /console

  config.assets.precompile += %w( teaspoon.css teaspoon-teaspoon.js jasmine/2.0.0.js jasmine/1.3.1.js teaspoon-jasmine.js)

  # Devise Mailers
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  config.action_mailer.preview_path = Rails.root.join('spec/mailers/previews')
  routes.default_url_options = { host: 'localhost', port: 3000 }
end
