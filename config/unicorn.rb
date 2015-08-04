worker_processes 2
working_directory "#{ENV['STACK_PATH']}"
timeout 15
check_client_connection false

preload_app true
GC.copy_on_write_friendly = true  if GC.respond_to?(:copy_on_write_friendly=)

listen "/tmp/web_server.sock", :backlog => 64
pid '/tmp/web_server.pid'
stderr_path "#{ENV['STACK_PATH']}/log/unicorn.stderr.log"
stdout_path "#{ENV['STACK_PATH']}/log/unicorn.stdout.log"


before_fork do |server, worker|
	old_pid = '/tmp/web_server.pid.oldbin'
	if File.exists?(old_pid) && server.pid != old_pid
		begin
			Process.kill("QUIT", File.read(old_pid).to_i)
		rescue Errno::ENOENT, Errno::ESRCH
			# someone else did our job for us
		end
	end

	if defined?(ActiveRecord::Base)
		ActiveRecord::Base.connection.disconnect!
  end

  if defined?(Resque)
    Resque.redis.quit
    Rails.logger.info('Disconnected from Redis')
  end
end


after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
		ActiveRecord::Base.establish_connection
  end

  if defined?(Resque)
    Resque.redis = Redis.new( AppConfig.redis )
    Resque.redis.namespace = AppConfig.redis.namespace
    Rails.logger.info('Connected to Redis')
  end

  # Reset the connections to memcache-based object and session stores - this
  # is using a dalli-specific reset method. Otherwise you'll get wacky cache
  # misreads (returning incorrect values for the requested key).
  # Rails.cache.reset if Rails.cache.respond_to?(:reset)
  # Rails.application.config.session_options[:cache] if Rails.application.config.session_options[:cache]

end
