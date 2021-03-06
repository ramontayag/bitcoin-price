require 'curb'
require 'oj'
require "active_support/inflections"
require "active_support/core_ext/integer"
require "bitcoin-price/fetcher"
require "bitcoin-price/cache_config"
require "bitcoin-price/check_cache_expiry"
require "bitcoin-price/set_cache"

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
      prices = Fetcher.fetch(url)
      if cache?
        SetCache.execute(prices)
      end
      prices
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
    !CheckCacheExpiry.execute(expires_at)
  end

  def self.cache_config
    @@cache_config
  end

end
