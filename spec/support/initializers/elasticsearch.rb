# require 'rake'
# require 'elasticsearch/extensions/test/cluster/tasks'
#
RSpec.configure do |config|

  config.before :all, elasticsearch: true do
    VCR.request_ignorer.ignore_localhost = true
    # Elasticsearch::Extensions::Test::Cluster.start unless Elasticsearch::Extensions::Test::Cluster.running?
  end

  config.after :all, elasticsearch: true do
    VCR.request_ignorer.ignore_localhost = false
  end

  # config.after :suite do
  #   VCR.request_ignorer.ignore_localhost = true
  #   Elasticsearch::Extensions::Test::Cluster.stop if Elasticsearch::Extensions::Test::Cluster.running?
  # end
  
  def index_model(klass, frequency=:all)
    before(frequency) do
      klass.__elasticsearch__.create_index!(force: true)
      klass.import
      wait_for_success(2) { klass.search('*').present? }
    end
    
    after(frequency) do
      klass.__elasticsearch__.create_index!(force: true)
    end
  end
  
  # Waits for elasticsearch to finish (doesn't sleep longer then needed)
  # tries again every tenths of a second
  def wait_for_success(seconds, options={})
    while (remaining_attempts ||= seconds*10) > 0 
      if yield
        remaining_attempts = 0
      else
        puts remaining_attempts if options[:loud]
        remaining_attempts -= 1
        sleep 0.1
      end
    end
  end
end