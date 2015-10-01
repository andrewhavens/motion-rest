# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'motion/rest/version'

Gem::Specification.new do |spec|
  spec.name          = "motion-rest"
  spec.version       = Motion::Rest::VERSION
  spec.authors       = ["Andrew Havens"]
  spec.email         = ["email@andrewhavens.com"]

  spec.summary       = %q{A RubyMotion model framework for RESTful JSON APIs.}
  # spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/andrewhavens/motion-rest"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
