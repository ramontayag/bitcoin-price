require "spec_helper"

module BitcoinPrice
  describe SetCache, ".execute" do

    let(:prices) do
      {
        "ask"=>"636.58",
        "last"=>"636.14",
        "bid"=>"634.88",
      }
    end

    let(:redis) { BitcoinPrice.redis }

    before do
      Timecop.freeze
    end

    it "sets the cache and updates the timestamp" do
      described_class.execute(prices)
      expected_expiry_time = Time.now +
        BitcoinPrice.cache_config.lifespan_in_minutes * 60
      expect(redis.get("bitcoin_price_cache_expires_at")).
        to eq(expected_expiry_time.to_s)
      expect(redis.hgetall("bitcoin_price_cached_prices")).to eq prices
    end

  end
end
