bitcoin-price
=============

Taking advantage of the firebase api to get the price of bitcoins.

require 'bitcoin-price'

BitcoinPrice.fetch will return bid / ask /last for prices in USD.

## Cache

You can optionally set the caching mechanism by:

```
BitcoinPrice.config do |c|
  c.cache = {
    lifespan_in_minutes: 5,
    redis_url: "redis://localhost:5678/0"
  }
end
```

You will need to `require "redis"` for this to work (you can add `gem "redis"` to your `Gemfile`).
