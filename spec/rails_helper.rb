ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'spec_helper'
require 'rspec_candy/all'
require 'webmock/rspec'
require 'vcr'
require 'pry'
# require "paperclip/matchers" # /support
# require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

# Requires shared_examples using the convention: _shared_example_name.rb (similar to view partials)
Dir.glob(Rails.root.join('spec/**/_*.rb')).each {|f| require f}

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include Devise::TestHelpers,      :type => :controller
  config.extend  Devise::ControllerHelper, :type => :controller
  config.extend  Devise::RequestHelper,    :type => :request
  config.include FactoryGirl::Syntax::Methods
  config.include Paperclip::Shoulda::Matchers
  
  # ## Mock Framework
  config.mock_with :rspec #:mocha

  VCR.configure do |c|
    c.default_cassette_options = { :record => :none } # :new_episodes
    c.allow_http_connections_when_no_cassette = false
    c.cassette_library_dir = "#{Rails.root}/spec/files/vcr_cassettes"
    c.hook_into :webmock
  end
  
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  
  config.infer_base_class_for_anonymous_controllers = true
  config.infer_spec_type_from_file_location!
  config.order = "random"
  
  config.infer_spec_type_from_file_location!
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end
  
  # Makes before(:all) useful again!
  config.before(:all) { DatabaseCleaner.start }
  config.after(:all)  {DatabaseCleaner.clean}
end