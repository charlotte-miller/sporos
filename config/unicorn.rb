worker_processes Integer(ENV["WEB_CONCURRENCY"] || 2)
working_directory "#{ENV['STACK_PATH']}"

listen "/tmp/web_server.sock", :backlog => 64

timeout 30

pid '/tmp/web_server.pid'

stderr_path "#{ENV['STACK_PATH']}/log/unicorn.stderr.log"
stdout_path "#{ENV['STACK_PATH']}/log/unicorn.stdout.log"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
	GC.copy_on_write_friendly = true

check_client_connection false

before_fork do |server, worker|
	old_pid = '/tmp/web_server.pid.oldbin'
	if File.exists?(old_pid) && server.pid != old_pid
		begin
			Process.kill("QUIT", File.read(old_pid).to_i)
		rescue Errno::ENOENT, Errno::ESRCH
			# someone else did our job for us
		end
	end

	defined?(ActiveRecord::Base) and
		ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
	defined?(ActiveRecord::Base) and
		ActiveRecord::Base.establish_connection
  
  # Reset the connections to memcache-based object and session stores - this                           
  # is using a dalli-specific reset method. Otherwise you'll get wacky cache                           
  # misreads (returning incorrect values for the requested key).                                       
  # Rails.cache.reset if Rails.cache.respond_to?(:reset)
  # Rails.application.config.session_options[:cache] if Rails.application.config.session_options[:cache]

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