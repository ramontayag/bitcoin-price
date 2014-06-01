module BitcoinPrice
  class Fetcher

    def self.fetch(url)
      c = Curl::Easy.perform(url)
      Oj.load(c.body_str)
    end

  end
end
