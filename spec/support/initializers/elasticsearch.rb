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
  
  def index_models(*klasses)
    options = klasses.extract_options!
    
    before(options[:frequency] || :all) do  
      puts "Indexing #{klasses.map(&:name).join(', ')}"
      es_indices = Elasticsearch::Model.client.indices
      
      # Clear and build indexes
      uniq_indexes_w_settings = klasses.inject({}) {|hash, klass| hash.update( klass.index_name => klass.settings.to_hash ) }
      uniq_indexes_w_settings.each_pair do |index_name, settings|
        es_indices.delete(index: index_name) if es_indices.exists(index: index_name)
        es_indices.create(index: index_name, body:{ settings: settings })
      end
      
      # Update Mappings & Import Data
      klasses.each do |searchable_klass|
        es_indices.put_mapping({
          index: searchable_klass.index_name,
          type:  searchable_klass.document_type,
          body:  searchable_klass.mappings.to_hash,
          # ignore_conflicts:true,
        })
        searchable_klass.import
      end

      klasses.each { |klass| wait_for_success(2) { klass.search('*').present? } }
    end
    
    after(options[:frequency] || :all) do
      klasses.map(&:index_name).uniq.each do |index|
        es_indices = Elasticsearch::Model.client.indices
        es_indices.delete(index: index) if es_indices.exists(index: index)
      end
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