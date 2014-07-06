module BitcoinPrice
  class CheckCacheExpiry

    def self.execute(expires_at)
      expires_at.blank? || Time.parse(expires_at) < Time.now
    end

  end
end
