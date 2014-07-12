source 'https://rubygems.org'

gem 'rails', '4.1.4'
gem 'mysql2'
gem 'configy'
gem 'oj'
gem 'whenever',          :require => false
gem 'sitemap_generator', :require => false
# gem 'ox'
# gem 'profanalyzer'


# Model Extentions
# ================
gem 'state_machine'
gem 'acts_as_list'
gem 'acts_as_interface'
gem 'devise'
gem 'devise-encryptable'
gem "friendly_id", '~> 5.0.4'
gem 'elasticsearch-rails'


# Media Download/Processing/Storage
# =================================
# gem 'anemone'
gem 'typhoeus'
gem 'cocaine'
gem 'posix-spawn'
gem 'aws-sdk'
gem 'paperclip'
gem 'paperclip-ffmpeg', git: 'git@github.com:chip-miller/paperclip-ffmpeg.git'
gem 'streamio-ffmpeg'
# gem 'paperclip-optimizer'


# Resque Queue
# =============
gem 'resque'
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
  gem 'sass-rails', '~> 4.0.3'
  gem 'coffee-rails', '~> 4.0.0'
  gem 'uglifier', '>= 1.3.0', :require => false
  # gem 'bootswatch-rails', git: 'git@github.com:log0ymxm/bootswatch-rails.git'
end

# gem 'jquery-rails'
gem 'therubyracer', :platforms => :ruby, :require => false
gem 'bootstrap-sass', '~> 3.2.0'
gem "haml-rails"
gem 'handlebars_assets'


group :development, :test do
  gem 'zeus'
  gem 'thin'
  # gem 'capistrano-rails', :require => nil
  
  # Jasmine
  gem 'jasmine-rails'
  gem 'jasmine-headless-webkit', '~> 0.8.4'

  # TDD
  gem 'growl'
  gem 'rb-fsevent'
  gem 'guard-rspec'#, '~> 3.0.2'
  gem 'guard-bundler'
  # gem 'guard-jasmine-headless-webkit'  # brew install qt --build-from-source
  
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
end

