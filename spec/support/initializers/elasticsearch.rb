# Some initalizers at the bottom of the file

RSpec.configure do |config|

  # config.before :suite do
  #   vcr_ignore_localhost do
  #     create_index_snapshot_for Page, Study, Lesson
  #   end
  # end
  
  config.before :all, elasticsearch: true do
    vcr_ignore_localhost do
      create_index_snapshot_for Page, Study, Lesson
    end
    VCR.request_ignorer.ignore_localhost = true
  end

  config.after :all, elasticsearch: true do
    VCR.request_ignorer.ignore_localhost = false
  end  
  
  
  # ======================================
  # =            Helpers                 =
  # ======================================
  
  def snapshot_as(name)
    es_snapshot = Elasticsearch::Model.client.snapshot
  
    begin #Find or create repository
      es_snapshot.get_repository repository:'elasticsearch-test'
  
    rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
      es_snapshot.create_repository({
        repository: 'elasticsearch-test',
        body: { 
          type: 'fs',
          settings: {
            location: Rails.root.join('tmp/elasticsearch-snapshot').to_s,
            compress:false 
          } 
        } 
      })
    end
  
    begin
      es_snapshot.create({
        repository: 'elasticsearch-test',
        snapshot: name,
        wait_for_completion:true,
        body: { indices:AppConfig.elasticsearch.index_name }
      })
    rescue Elasticsearch::Transport::Transport::Errors::BadRequest => e
      es_snapshot.delete({
        repository: 'elasticsearch-test',
        snapshot: name })
      retry
    end
  end
  
  def reset_index_snapshot(snapshot_name='empty_index_and_mappings')
    Elasticsearch::Model.client.indices.close({index:AppConfig.elasticsearch.index_name})
    Elasticsearch::Model.client.snapshot.restore({
      repository: 'elasticsearch-test',
      snapshot: snapshot_name,
      wait_for_completion:true
    })
  end
  
  # deletes existing index & snapshot
  def create_index_snapshot_for(*klasses)
    options = klasses.extract_options!
    
    puts "Creating Index Snapshot for #{klasses.map(&:name).join(', ')}"
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
      })
    end
    
    snapshot_as('empty_index_and_mappings')
  end
  
  def import_models(*klasses)
    options = klasses.extract_options!
    
    before(options[:frequency] || :all) do
      reset_index_snapshot
      klasses.each(&:import)
      klasses.each { |klass| wait_for_success(2) { klass.search('*').present? } }
    end
  end
  
  # DEPRECATED - Leave messy then cleanup as part of setup
  # def delete_index_and_snapshot
  #   puts "Deleting Index & Snapshot"
  #   es_indices = Elasticsearch::Model.client.indices
  #   index_name = AppConfig.elasticsearch.index_name
  #   es_indices.delete(index: index_name) if es_indices.exists(index: index_name)
  #
  #   # delete snapshot file
  #   Elasticsearch::Model.client.snapshot.delete({
  #     repository: 'elasticsearch-test',
  #     snapshot: 'empty_index_and_mappings'
  #   })
  # end  
  
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
  
  def vcr_ignore_localhost
    VCR.request_ignorer.ignore_localhost = true
    yield
    VCR.request_ignorer.ignore_localhost = false
  end
end


# ================================
# =         Run on Load          =
# ================================
# WebMock.disable_net_connect!(:allow_localhost => true)
# create_index_snapshot_for Page, Study, Lesson
# WebMock.disable_net_connect!(:allow_localhost => false)