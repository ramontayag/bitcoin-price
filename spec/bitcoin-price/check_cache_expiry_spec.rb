require "spec_helper"

module BitcoinPrice
  describe CheckCacheExpiry, ".execute" do

    subject { described_class.execute(expired_at) }

    context "expires at is blank" do
      let(:expired_at) { "" }
      it { is_expected.to be_truthy }
    end

    context "expires at is nil" do
      let(:expired_at) { nil }
      it { is_expected.to be_truthy }
    end

    context "expires at is a time in the future" do
      let(:expired_at) { 10.minutes.from_now.to_s }
      it { is_expected.to be_falsey }
    end

    context "expires at is a time in the past" do
      let(:expired_at) { 10.minutes.ago.to_s }
      it { is_expected.to be_truthy }
    end

  end
end
