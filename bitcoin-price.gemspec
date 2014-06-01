# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bitcoin-price/version'

Gem::Specification.new do |spec|
  spec.name          = "bitcoin-price"
  spec.version       = BitcoinPrice::VERSION
  spec.authors       = ["blooberr"]
  spec.email         = ["blooberr@gmail.com"]
  spec.description   = %q{Get real time bitcoin prices from firebase.}
  spec.summary       = spec.description
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'curb'
  spec.add_dependency 'oj'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "redis"
  spec.add_development_dependency "timecop"
end
