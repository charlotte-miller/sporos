
namespace :queues do

  desc "Run Resque workers with options and job classes loaded"
  # Run with & appended to daemonize
  task :workers => :environment do

    def pid_directory
      Rails.root.join('tmp', 'pids')
    end

    def kill_forks_and_remove_pids
      Dir.glob(pid_directory.join('worker_*.pid').to_s) do |pidfile|
        begin
          pid = pidfile[/worker_(\d+)\.pid/, 1].to_i
          Process.kill("QUIT", pid)
          puts "Killed worker with PID #{pid}"
        rescue Errno::ESRCH => e
          puts "Stale #{pidfile}"
        ensure
          FileUtils.rm pidfile, :force => true
        end
      end
    end

    trap('INT')  do
      puts "*** Exiting"
      kill_forks_and_remove_pids
      exit(0)
    end

    # Set options, override when invoking
    # ENV['VERBOSE'] ||= 'true'
    ENV['QUEUE']   ||= '*'
    ENV['COUNT']   ||= '1'

    kill_forks_and_remove_pids

    puts "=== Launching #{ENV['COUNT']} worker(s) on '#{ENV['QUEUE']}' queue(s) with PID #{Process.pid}"

    # Launch workers in separate processes
    pids = []
    ENV['COUNT'].to_i.times do
      pids << Process.fork { Rake::Task['resque:work'].invoke }
    end

    # Create PID files for workers
    FileUtils.mkdir_p pid_directory.to_s
    pids.each do |pid|
      File.open( pid_directory.join("worker_#{pid}.pid").to_s, 'w' ) { |f| f.write pid }
    end

    Process.wait
  end

end
