require "spec_helper"

module BitcoinPrice
  describe Fetcher, ".fetch" do

    it "returns the exchange rate, in USD, per Bitcoin", vcr: {record: :once} do
      prices = described_class.fetch(BitcoinPrice::DEFAULT_SOURCE_URL)
      %w(ask last bid).each do |type|
        expect(prices[type]).to match(/\d{1,}\.\d{2}/)
      end
    end

  end
end
