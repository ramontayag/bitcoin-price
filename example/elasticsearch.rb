require 'elasticsearch'
require 'bitcoin-price'
require 'time'

# index bitcoin prices over time

es = Elasticsearch::Client.new log: true

loop do
  price = BitcoinPrice.fetch
  es.index index: "bitcoin",
           type: "USD",
           body: {
             :prices => price,
             :"@timestamp" => Time.now.utc.iso8601}

  sleep 10
end

