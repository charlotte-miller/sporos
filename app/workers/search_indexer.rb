# class SearchIndexer
#   extend Resque::Plugins::Retry #https://github.com/lantins/resque-retry
#   @queue = :search
#
#   class << self
#     def perform_async(*args)
#       Resque.enqueue(AttachmentDownloader, *args)
#     end
#
#     def perform(*args)
#       new.perform(*args)
#     end
#   end
#
#   def perform(obj_hash, attachment_names=[])
#     @obj_instance = obj_hash.to_obj
#     @obj_instance.index
#
#     Logger = Sidekiq.logger.level == Logger::DEBUG ? Sidekiq.logger : nil
#     Client = Elasticsearch::Client.new host: 'localhost:9200', logger: Logger
#
#     logger.debug [operation, "ID: #{record_id}"]
#
#     case operation.to_s
#       when /index/
#         record = Article.find(record_id)
#         Client.index  index: 'articles', type: 'article', id: record.id, body: record.as_indexed_json
#       when /delete/
#         Client.delete index: 'articles', type: 'article', id: record_id
#       else raise ArgumentError, "Unknown operation '#{operation}'"
#     end
#   end
#
# private
#
# end
