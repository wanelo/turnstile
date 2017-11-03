# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'turnstile/version'

Gem::Specification.new do |spec|
  spec.name          = 'turnstile'
  spec.version       = Turnstile::VERSION
  spec.authors       = ['Konstantin Gredeskoul', 'Atasay Gokkaya']
  spec.email         = %w(kigster@gmail.com atasay@wanelo.com)
  spec.summary       = %q{Asynchronous and non-invasive concurrent user tracking with Redis, by scanning application logs across all servers.}
  spec.description   = %q{Asynchronous and non-invasive concurrent user tracking with Redis, by scanning application logs across all servers.}
  spec.homepage      = 'https://github.com/wanelo/turnstile'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'redis'
  spec.add_dependency 'file-tail'
  spec.add_dependency 'daemons'
  spec.add_dependency 'json'
  spec.add_dependency 'hashie'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'rb-fsevent'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
