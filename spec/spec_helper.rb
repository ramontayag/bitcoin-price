require "bundler/setup"
Bundler.require(:defaults, :development)

require "bitcoin-price"

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end
