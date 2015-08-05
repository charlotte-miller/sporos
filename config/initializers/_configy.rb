unless defined? AppConfig
  Configy.cache_config = true unless Rails.env.development?
  Configy.create(:app_config)
end
