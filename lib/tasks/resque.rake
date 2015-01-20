require 'resque/tasks'
require 'resque/scheduler/tasks'
task "resque:setup" => :environment

task "resque:background" => 'environment' do
  ENV['PIDFILE']=Rails.root.join('tmp/pids', 'resque.pid').to_s
  ENV['BACKGROUND']='yes'
  ENV['QUEUE']='*'
  Rake::Task[ 'resque:work' ].execute
end