# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'file_sorter/version'

Gem::Specification.new do |spec|
  spec.name          = "file_sorter"
  spec.version       = FileSorter::VERSION
  spec.authors       = ["Jon Riddle"]
  spec.email         = ["jon@jdrnetworking.com"]
  spec.description   = %q{FileSorter does things to files}
  spec.summary       = %q{Matches files on glob or regex, performs custom behavior. Intended to be run periodically.}
  spec.homepage      = "https://github.com/jdrnetworking/filesorter"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 3.2.14"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "mocha"
end
