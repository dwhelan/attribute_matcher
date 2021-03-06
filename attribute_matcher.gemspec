# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'attribute_matcher/version'

Gem::Specification.new do |gem|
  gem.name          = 'attribute_matcher'
  gem.version       = HaveAttributeMatcher::VERSION
  gem.authors       = ['Declan Whelan']
  gem.email         = ['declan@pleanintuit.com']
  gem.summary       = 'A matcher for testing object attributes.'
  gem.description   = 'A matcher for testing object attributes.'
  gem.homepage      = 'https://github.com/dwhelan/attribute_matcher'
  gem.license       = 'MIT'

  gem.files         = `git ls-files -z`.split("\x0")
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler',                 '~>  1.7'
  gem.add_development_dependency 'coveralls',               '~>  0.8'
  gem.add_development_dependency 'guard',                   '~>  2.13'
  gem.add_development_dependency 'guard-rspec',             '~>  4.6'
  gem.add_development_dependency 'rake',                    '~> 10.0'
  gem.add_development_dependency 'rspec',                   '~>  3.0'
  gem.add_development_dependency 'rspec-its',               '~>  1.2'
  gem.add_development_dependency 'rubocop',                 '~>  0.30'
  gem.add_development_dependency 'simplecov',               '~>  0.9'
  gem.add_development_dependency 'terminal-notifier-guard', '~>  1.6'
  gem.add_development_dependency 'virtus',                  '~>  1.0'
end
