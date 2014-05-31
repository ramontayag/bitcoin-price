require "spec_helper"

describe BitcoinPrice do

  it "returns the exchange rate, in USD, per Bitcoin", vcr: {record: :once} do
    prices = described_class.fetch
    %w(ask last bid).each do |type|
      expect(prices[type]).to match(/\d{1,}\.\d{2}/)
    end
  end

end
