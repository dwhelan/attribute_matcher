# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'have_attribute_matcher/version'

Gem::Specification.new do |gem|
  gem.name          = 'have_attribute_matcher'
  gem.version       = HaveAttributeMatcher::VERSION
  gem.authors       = ['Declan Whelan']
  gem.email         = ['declan@pleanintuit.com']
  gem.summary       = 'A matcher for testing object attributes.'
  gem.description   = 'A matcher for testing object attributes.'
  gem.homepage      = 'https://github.com/dwhelan/have_attribute_matcher'
  gem.license       = 'MIT'

  gem.files         = `git ls-files -z`.split("\x0")
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler',                   '~>  1.7'
  gem.add_development_dependency 'codeclimate-test-reporter', '~>  0.4'
  gem.add_development_dependency 'coveralls',                 '~>  0.7'
  gem.add_development_dependency 'rake',                      '~> 10.0'
  gem.add_development_dependency 'rspec',                     '~>  3.0'
  gem.add_development_dependency 'rspec-its',                 '~>  1.1'
  gem.add_development_dependency 'rubocop',                   '~>  0.30'
end
