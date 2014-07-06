require 'curb'
require 'oj'
require "bitcoin-price/fetcher"
require "bitcoin-price/cache_config"

module BitcoinPrice

  DEFAULT_SOURCE_URL = "https://publicdata-bitcoin.firebaseio.com/.json"

  def self.cache=(config)
    @@cache_config = if config
                       CacheConfig.new(config)
                     else
                       false
                     end
  end

  def self.redis
    unless defined?(Redis)
      fail "To use redis, you must have required `redis`"
    end
    @@redis ||= Redis.new(url: cache_config.redis_url)
  end

  def self.fetch(url=DEFAULT_SOURCE_URL)
    if cache? && cache_alive?
      cached_prices = redis.hgetall("bitcoin_price_cached_prices")
      cached_prices.each do |k, v|
        cached_prices[k] = v.to_f
      end
      cached_prices
    else
      if cache?
        redis.set(
          "bitcoin_price_cache_expires_at",
          Time.now + cache_config.lifespan_in_minutes * 60,
        )
      end
      Fetcher.fetch(url)
    end
  end

  def self.configure(&config)
    yield self
  end

  private

  def self.cache?
    !!self.cache_config
  end

  def self.cache_alive?
    expires_at = redis.get("bitcoin_price_cache_expires_at")
    expires_at != "" && Time.now < Time.parse(expires_at)
  end

  def self.cache_config
    @@cache_config
  end

end
