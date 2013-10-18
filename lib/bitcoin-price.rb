require 'curb'
require 'oj'

module BitcoinPrice

  def fetch(url="https://publicdata-bitcoin.firebaseio.com/.json")
    c = Curl::Easy.perform(url)
    Oj.load(c.body_str)
  end

  extend self
end

