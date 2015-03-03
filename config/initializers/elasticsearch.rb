# Configuration options
# https://github.com/elasticsearch/elasticsearch-ruby/blob/master/elasticsearch-transport%2Flib%2Felasticsearch%2Ftransport%2Fclient.rb

Elasticsearch::Model.client = Elasticsearch::Client.new({
  log:    true,
  logger: Logger.new( Rails.root.join("log/elasticsearch#{Rails.env.test? ? '-test' : ''}.log") ),
  retry_on_failure: Rails.env.test? ? false : 2
})