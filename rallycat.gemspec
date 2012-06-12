# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rallycat/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Adam Tanner", "Emilio Cavazos"]
  gem.email         = ["adam@adamtanner.org"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

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

end
