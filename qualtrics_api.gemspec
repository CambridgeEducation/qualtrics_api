# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'qualtrics_api/version'

Gem::Specification.new do |spec|
  spec.name          = "qualtrics_api"
  spec.version       = QualtricsAPI::VERSION
  spec.authors       = ["Yurui Zhang"]
  spec.email         = ["yuruiology@gmail.com"]
  spec.summary       = %q{A Ruby wrapper for Qualtrics REST API v3.0}
  spec.description   = %q{A Ruby wrapper for Qualtrics REST API version 3.0.
                          See https://co1.qualtrics.com/APIDocs/ for API documents.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 0.9.1"
  spec.add_dependency "faraday_middleware", "~> 0.9.1"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2.0"
end
