# -*- encoding: utf-8 -*-
require File.expand_path('../lib/md_data/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["drKreso"]
  gem.email         = ["kresimir.bojcic@gmail.com"]
  gem.description   = %q{Describe multidimensional data with simple notation}
  gem.summary       = %q{Easy way to descriebe and find values from multidimensional table.}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "https://github.com/drKreso/md_data"
  gem.require_paths = ["lib"]
  gem.version       = MdData::VERSION
end
