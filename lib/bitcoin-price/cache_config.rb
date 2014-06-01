module BitcoinPrice
  class CacheConfig

    attr_accessor :lifespan_in_minutes, :redis_url

    def initialize(config)
      @lifespan_in_minutes = config.fetch(:lifespan_in_minutes)
      @redis_url = config.fetch(:redis_url)
    end

  end
end
