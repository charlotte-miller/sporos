source 'https://rubygems.org'

gem 'rails', '4.2.0.beta1'
gem 'sass-rails', '~> 5.0.0.beta1'

gem 'mysql2'
gem 'configy'
gem 'oj'
gem 'whenever',          :require => false
gem 'sitemap_generator', :require => false
gem 'parallel'
# gem 'ox'
# gem 'profanalyzer'
# gem 'truncate_html'


# Model Extentions
# ================
gem 'state_machine'
gem 'acts_as_list'
gem 'acts_as_interface'
gem 'devise'
gem 'devise-encryptable'
gem "friendly_id", '~> 5.0.4'
gem 'kaminari'

# Search
# =======
# gem 'elasticsearch-rails'
gem 'searchkick'
gem "searchjoy"
gem 'patron'


# Media Download/Processing/Storage
# =================================
# gem 'anemone'
# gem 'typhoeus'
gem 'cocaine'
gem 'posix-spawn'
gem 'aws-sdk'
gem 'paperclip'
# gem 'paperclip-ffmpeg', git: 'git@github.com:chip-miller/paperclip-ffmpeg.git'
# gem 'streamio-ffmpeg'
# gem 'paperclip-optimizer'


# Resque Queue
# =============
gem 'resque'
gem 'resque-web'
gem 'resque-retry'
gem 'redis-sentinel'
# gem 'redis-store'
# gem "redis", "~> 3.0.1", :require => ["redis"]
# gem "redis-namespace", "~> 1.2.0"
# gem "newrelic-redis"
# gem "thin", "~> 1.4.1"
# gem 'slim', '<= 1.3.0'
# gem 'sinatra', :require => nil


# Monitoring
# ==========
gem 'newrelic_rpm'
gem 'airbrake'

group :production do
  gem 'unicorn'
end

# Not required in production environments by default.
group :assets do
  # gem 'sass-rails', '~> 4.0.3'
  gem 'coffee-rails', '~> 4.0.0'
  gem 'uglifier', '>= 1.3.0', :require => false
end

# gem 'jquery-rails'
gem 'therubyracer', :platforms => :ruby, :require => false
gem 'bootstrap-sass', '~> 3.2.0'
gem "haml-rails"
gem 'handlebars_assets'


group :development, :test do
  gem "bower-rails"
  
  gem 'zeus'
  gem 'thin'
  # gem 'capistrano-rails', :require => nil
  
  # TDD
  gem 'ruby_gntp'
  gem 'rb-fsevent'
  gem 'guard-rspec'#, '~> 3.0.2'
  gem 'guard-bundler'
  gem 'jasmine-rails'
  gem 'guard-jasmine', git:'git@github.com:guard/guard-jasmine.git', branch:'jasmine-2'
  
  # Rspec
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'timecop'
  gem "faker"
  gem 'minitest'
  gem 'shoulda-matchers', '~> 2.6.0'
  gem 'rspec_candy'
  gem 'syntax'
  gem 'vcr'
  gem "rspec-instafail"
  # gem 'capybara'
  # gem 'capybara-webkit'
  # gem 'capybara-screenshot', git:'git@github.com:mattheworiordan/capybara-screenshot.git'
  
  # Debugger
  gem 'pry-rails'
  gem 'progress_bar'
  # gem 'web-console', '~> 2.0'
  
  # Documentation
  gem 'annotate', ">=2.5.0"
  gem 'sdoc', '~> 0.4.0'
  
  gem 'quiet_assets'
  gem 'rails-backbone-generator', :require => false  
  # gem 'activerecord-import', '~> 0.3.0' #for seed file
end

group :test do
  gem 'webmock'
  gem 'simplecov', :require => false
  gem "activerecord-tableless", "~> 1.0"  #used by DummyClass when testing concerns
  gem "resque_spec"
  gem "fakeredis", :require => "fakeredis/rspec"
end

