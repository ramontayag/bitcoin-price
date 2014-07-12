module BitcoinPrice
  class SetCache

    def self.execute(prices)
      expiry_time = Time.now + BitcoinPrice.cache_config.lifespan_in_minutes * 60
      redis.set("bitcoin_price_cache_expires_at", expiry_time)
      redis.mapped_hmset("bitcoin_price_cached_prices", prices)
    end

    private

    def self.redis
      BitcoinPrice.redis
    end

  end
end
