# USAGE:
#
#   describe SomeClass, resque: :fake do
#     # tests
#   end
#
#   describe SomeOtherClass, resque: :inline do
#     # tests
#   end
#
#
RSpec.configure do |config|
  config.before(:each) do |example|
    # Clears out the jobs for tests using the fake testing
    ResqueSpec.reset!

    if example.metadata[:resque].try(:to_sym)    == :fake
      ResqueSpec.disable_ext = false
    elsif example.metadata[:resque].try(:to_sym) == :inline
      # ResqueSpec.disable_ext = true
      ResqueSpec.inline = true
    elsif example.metadata[:type].try(:to_sym)   == :acceptance
      ResqueSpec.disable_ext = true
    else
      ResqueSpec.disable_ext = false
      ResqueSpec.inline = false
    end
  end
end

# https://github.com/resque/resque/wiki/RSpec-and-Resque
# RSpec.configure do |config|
#   REDIS_PID = "#{Rails.root}/tmp/pids/redis-test.pid"
#   REDIS_CACHE_PATH = "#{Rails.root}/tmp/cache/"
#
#   config.before(:suite) do
#     redis_options = {
#       "daemonize"     => 'yes',
#       "pidfile"       => REDIS_PID,
#       "port"          => 9736,
#       "timeout"       => 300,
#       "save 900"      => 1,
#       "save 300"      => 1,
#       "save 60"       => 10000,
#       "dbfilename"    => "dump.rdb",
#       "dir"           => REDIS_CACHE_PATH,
#       "loglevel"      => "debug",
#       "logfile"       => "stdout",
#       "databases"     => 16
#     }.map { |k, v| "#{k} \"#{v}\"" }.join("\n")
#     `echo '#{redis_options}' | redis-server -`
#   end
#
#   config.after(:suite) do
#     %x{
#       cat "#{REDIS_PID}" | xargs kill -QUIT
#       rm -f "#{REDIS_CACHE_PATH}dump.rdb"
#     }
#   end
# end
