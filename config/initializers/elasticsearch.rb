Elasticsearch::Model.client = Elasticsearch::Client.new(url: ENV['ELASTICSEARCH_URL'], log: true, retry_on_failure: true)

if Elasticsearch::Model.client.ping
  puts '----------------------------Elasticsearch connection is active and reachable.----------------------'
else
  puts '--------------Failed to connect to Elasticsearch.-------------------'
end
