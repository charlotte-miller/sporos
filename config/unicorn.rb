worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 15
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
  
  # Reset the connections to memcache-based object and session stores - this                           
  # is using a dalli-specific reset method. Otherwise you'll get wacky cache                           
  # misreads (returning incorrect values for the requested key).                                       
  Rails.cache.reset if Rails.cache.respond_to?(:reset)                                                 
  Rails.application.config.session_options[:cache] if Rails.application.config.session_options[:cache]

  # redis_url = AppConfig.redis.host
  # redis_namespace = "sporos:resque"
  # redis_config = {:url => redis_url, :namespace => redis_namespace}
  #
  # Sidekiq.configure_client do |config|
  #   config.redis = redis_config
  #   config.client_middleware do |chain|
  #     chain.add RequestStore::SidekiqMiddleware
  #   end
  # end
  
end