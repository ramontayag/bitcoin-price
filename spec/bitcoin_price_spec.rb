require "spec_helper"

describe BitcoinPrice, ".fetch" do

  context "without caching" do
    it "fetches the prices" do
      described_class.configure do |c|
        c.cache = false
      end
      prices = {
        "ask" => 10.0,
        "bid" => 11.0,
        "last" => 12.0,
      }
      allow(BitcoinPrice::Fetcher).to receive(:fetch).and_return(prices)
      expect(described_class.fetch).to eq prices
    end
  end

  context "with caching" do
    context "has not fetched prices before" do
      before do
        described_class.redis.set("bitcoin_price_cache_expires_at", nil)
      end

      it "fetches the prices" do
        prices = {
          "ask" => 10.0,
          "bid" => 11.0,
          "last" => 12.0,
        }
        allow(BitcoinPrice::Fetcher).to receive(:fetch).and_return(prices)
        expect(described_class.fetch).to eq prices
      end
    end

    context "cache has expired" do
      before do
        Timecop.freeze

        described_class.configure do |c|
          c.cache = {
            lifespan_in_minutes: 3,
            redis_url: "redis://127.0.0.1:6379/0",
          }
        end
      end

      it "fetches the prices and updates the cache expiry time" do
        cached_prices = {
          "ask" => 20.0,
          "bid" => 21.0,
          "last" => 22.0,
        }
        described_class.redis.mapped_hmset(
          "bitcoin_price_cached_prices",
          cached_prices,
        )
        described_class.redis.set "bitcoin_price_cache_expires_at", Time.now - 5
        fresh_prices = {
          "ask" => 10.0,
          "bid" => 11.0,
          "last" => 12.0,
        }
        allow(BitcoinPrice::Fetcher).to receive(:fetch).and_return(fresh_prices)
        expect(described_class.fetch).to eq fresh_prices
        expires_at = described_class.redis.get("bitcoin_price_cache_expires_at")
        expect(expires_at).to eq (Time.now + 3 * 60).to_s
      end
    end

    context "cache has not expired" do
      it "returns the cached prices" do
        cached_prices = {
          "ask" => 20.0,
          "bid" => 21.0,
          "last" => 22.0,
        }
        described_class.redis.mapped_hmset(
          "bitcoin_price_cached_prices",
          cached_prices,
        )
        described_class.redis.set "bitcoin_price_cache_expires_at", Time.now + 5
        expect(described_class.fetch).to eq cached_prices
      end
    end
  end

end
