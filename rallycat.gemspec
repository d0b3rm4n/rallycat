# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rallycat/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Adam Tanner", "Emilio Cavazos"]
  gem.email         = ["adam@adamtanner.org", "ejcavazos@gmail.com"]
  gem.description   = %q{The Rally website sucks. CLI is better.}
  gem.summary       = %q{The Rally website sucks. CLI is better.}
  gem.homepage      = "https://github.com/adamtanner/rallycat"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rallycat"
  gem.require_paths = ["lib"]
  gem.version       = Rallycat::VERSION

  # rally depends on this but does not declare it as a dependency
  gem.add_dependency 'builder'
  gem.add_dependency 'rally_rest_api'
  gem.add_dependency 'nokogiri'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'artifice'
  gem.add_development_dependency 'rspec'
end
