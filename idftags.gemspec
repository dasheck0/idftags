# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'IDFTags/version'

Gem::Specification.new do |spec|
  spec.name          = "idftags"
  spec.version       = IDFTags::VERSION
  spec.authors       = ["Stefan Neidig"]
  spec.email         = ["stefan@rpdev.net"]

  spec.summary       = %q{IDFTags generates tags based on text and documents.}
  spec.description   = %q{IDFTags generates tags based on text and documents. It uses inverse document frequency to calculate the meaning of words.}
  spec.homepage      = "https://github.com/dasheck0/idftags"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
