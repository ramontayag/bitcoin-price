require "spec_helper"

module BitcoinPrice
  describe CacheConfig do

    describe "initialization" do
      it "accepts correctly formed options" do
        config = described_class.new(
          lifespan_in_minutes: 5,
          redis_url: "redis://abc.com:1230/0",
        )
        expect(config.lifespan_in_minutes).to eq 5
        expect(config.redis_url).to eq "redis://abc.com:1230/0"
      end

      context "incorrect options are given" do
        it "complains" do
          expect {
            described_class.new(a: "abc")
          }.to raise_error
        end
      end
    end

  end
end
