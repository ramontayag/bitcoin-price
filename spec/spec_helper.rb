require "bundler/setup"
Bundler.require(:defaults, :development)

require "bitcoin-price"
require "redis"
require "pry"

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

RSpec.configure do |c|
  c.before :each do
    BitcoinPrice.configure do |config|
      config.cache = {
        lifespan_in_minutes: 5,
        redis_url: "redis://127.0.0.1:6379/0",
      }
    end
    BitcoinPrice.redis.set("bitcoin_price", nil)
    Timecop.return
  end
end
