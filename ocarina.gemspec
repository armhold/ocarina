# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ocarina/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["George Armhold"]
  gem.email         = ["armhold@gmail.com"]
  gem.description   = %q{A Ruby project that uses machine learning to perform Optical Character Recognition}
  gem.summary       = %q{A Ruby project that uses machine learning to perform Optical Character Recognition}
  gem.homepage      = "https://github.com/armhold/ocarina"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ocarina"
  gem.require_paths = ["lib"]
  gem.version       = Ocarina::VERSION

  gem.add_runtime_dependency 'rmagick'
  gem.add_runtime_dependency 'powerbar'
  gem.add_development_dependency 'ruby-prof'
end
