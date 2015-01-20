require 'resque/tasks'
require 'resque/scheduler/tasks'
task "resque:setup" => :environment

task "resque:background:start" => 'environment' do
  ENV['PIDFILE']=Rails.root.join('tmp/pids', 'resque.pid').to_s
  ENV['BACKGROUND']='yes'
  ENV['QUEUE']='*'
  Rake::Task[ 'resque:work' ].execute
end

task "resque:background:stop" => 'environment' do
  pid_file = Rails.root.join('tmp/pids/resque.pid')
  pid      = File.read(pid_file).to_i
  
  raise "Resque Not Running As Expected" unless pid_file
  Process.kill( 'QUIT', pid )
  File.delete(pid_file)
end