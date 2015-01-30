require 'resque/tasks'
require 'resque/scheduler/tasks'

task "resque:background:start" => 'environment' do
  pid_file = Rails.root.join('tmp/pids/resque.pid')
  raise "Resque Already Running - stop it first or manually rm tmp/pids/resque.pid" if File.exists? pid_file
  
  ENV['PIDFILE']=Rails.root.join('tmp/pids', 'resque.pid').to_s
  ENV['BACKGROUND']='yes'
  Rake::Task[ 'resque:work' ].invoke
end

task "resque:background:stop" => 'environment' do
  pid_file = Rails.root.join('tmp/pids/resque.pid')
  pid      = File.read(pid_file).to_i
  
  raise "Resque Not Running As Expected" unless pid_file
  Process.kill( 'QUIT', pid )
  File.delete(pid_file)
end

# be rake resque:work
task "resque:setup" => :environment do
  ENV['QUEUE'] ||= '*'
  #for redistogo on heroku http://stackoverflow.com/questions/2611747/rails-resque-workers-fail-with-pgerror-server-closed-the-connection-unexpectedl
  Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
end
