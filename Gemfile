ruby '2.1.2'
source 'https://rubygems.org'

gem 'firebase_token_generator'

gem 'rails', '~> 4.2.0'
gem 'sass-rails', '~> 5.0.0.beta1'

gem 'pg'
gem 'configy'
gem 'oj'
gem 'rack-cache'
gem 'kgio'
gem 'sitemap_generator', :require => false
gem 'redcarpet' #markdown for legacy_pages
gem 'net-ssh-gateway', require:false
# gem 'ox'
# gem 'profanalyzer'
# gem 'truncate_html'


# Model Extentions
# ================
gem 'aasm', '~>4.0.1'
gem 'acts_as_list'
gem 'acts_as_interface'
gem 'devise', '>= 2.0.0'
gem 'devise_invitable', '~> 1.3.4'
gem 'cancancan', '~> 1.10.1'
gem "friendly_id", '~> 5.0.4'
gem 'kaminari'  #see config/initializers/kaminari_config.rb
gem 'protected_attributes'
gem 'awesome_nested_set', '~> 3.0.2'

# Search
# =======
gem 'elasticsearch', '~> 1.0.12'
gem 'elasticsearch-model', require: 'elasticsearch/model'
gem 'elasticsearch-rails', require: false
# gem 'searchkick'
gem "searchjoy"


# Media Download/Processing/Storage
# =================================
# gem 'anemone'
gem 'typhoeus'
gem 'cocaine'
gem 'posix-spawn'
gem 'aws-sdk'
gem 'paperclip', '>= 4.2.1' #git:'https://github.com/thoughtbot/paperclip.git'
gem 'delayed_paperclip',  '>= 2.9.0'#,  git:'https://github.com/jrgifford/delayed_paperclip.git'
gem 'link_thumbnailer'
gem 'paperclip-optimizer'
gem 'image_optim'
gem 'image_optim_pack'
# gem 'jquery-fileupload-rails' #https://github.com/tors/jquery-fileupload-rails#using-the-middleware


# Resque Queue
# =============
gem 'resque', '~> 1.25.2'
gem 'resque-scheduler'
gem 'resque_mailer'
gem 'resque-retry'
# gem 'resque-multi-job-forks', git:'https://github.com/stulentsev/resque-multi-job-forks

gem "redis", "~> 3.1.0", :require => ["redis"]
gem 'hiredis'
gem 'redis-rails'
gem "redis-namespace"
gem "redis-rack-cache"
# gem 'redis-sentinel'
# gem "newrelic-redis"

# gem "thin", "~> 1.4.1"
# gem 'slim', '<= 1.3.0'
# gem 'sinatra', :require => nil

# Legacy
gem 'rack-slashenforce'#, :require => 'rack'
gem 'rack-rewrite', '~> 1.5.0'#, require:'rack/rewrite'

# Monitoring
# ==========
gem 'newrelic_rpm'
gem 'airbrake'

# Design
# ==========
gem 'font-awesome-sass'

group :production do
  gem 'unicorn'
  gem 'unicorn-worker-killer'
end

# Not required in production environments by default.
group :assets do
  # gem 'sass-rails', '~> 4.0.3'
  gem 'coffee-rails', '~> 4.0.0'
  gem 'uglifier', '>= 1.3.0', :require => false
  gem "bower-rails"
  gem 'bourbon'
end

gem 'gon'
gem 'therubyracer', :platforms => :ruby, :require => false
gem 'bootstrap-sass', '~> 3.3.4'
gem 'devise-bootstrap-views'
gem 'jquery-rails'
gem "haml-rails"
gem 'handlebars_assets'#, '0.17.1'
gem 'lorem_ipsum_amet' #, :group => :development
gem 'react-rails'

gem 'ansi'

group :development, :test do
  gem "erb2haml"
  # gem "bullet"

  gem 'zeus'
  gem 'thin'
  # gem 'capistrano-rails', :require => nil

  # TDD
  gem 'growl'
  gem 'rb-fsevent'
  gem 'guard-rspec'#, '~> 3.0.2'
  gem 'guard-bundler', require: false
  gem "teaspoon"
  gem "guard-teaspoon"

  # Rspec
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'timecop'
  gem "faker"
  gem 'minitest'
  gem 'shoulda-matchers', '~> 2.7.0', require:false
  gem 'rspec-activemodel-mocks'
  gem 'rspec-collection_matchers'
  gem 'rspec_candy'
  gem 'syntax'
  gem 'vcr'
  gem "rspec-instafail"
  gem 'database_cleaner'
  # gem 'capybara'
  # gem 'capybara-webkit'
  # gem 'capybara-screenshot', git:'git@github.com:mattheworiordan/capybara-screenshot.git'

  # Debugger
  gem 'awesome_print'
  gem 'pry-rails'
  gem 'progress_bar'
  # gem 'web-console', '~> 2.0'

  # Documentation
  gem 'annotate', ">=2.5.0"
  gem 'sdoc', '~> 0.4.0'

  gem 'quiet_assets'
  gem 'rails-backbone-generator', require:false #, path:'~/development/Gems/rails-backbone-generator'
  # gem 'activerecord-import', '~> 0.3.0' #for seed file

  gem 'git', require:false
end

group :test do
  gem 'webmock'
  gem 'simplecov', :require => false
  gem "activerecord-tableless", ">= 1.3.4",  git:'https://github.com/david135/activerecord-tableless.git' #https://github.com/softace/activerecord-tableless.git' #used by DummyClass when testing concerns
  gem "resque_spec"
  gem "fakeredis", :require => "fakeredis/rspec"
  # gem 'elasticsearch-extensions'
  # gem 'mock_redis', ">= 0.14.0"
end

