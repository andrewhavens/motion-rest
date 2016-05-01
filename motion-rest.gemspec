# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "motion-rest"
  spec.version       = "1.0.0"
  spec.authors       = ["Andrew Havens"]
  spec.email         = ["email@andrewhavens.com"]

  spec.summary       = %q{A RubyMotion model framework for integrating with RESTful JSON APIs.}
  spec.homepage      = "https://github.com/andrewhavens/motion-rest"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "afmotion"
  spec.add_runtime_dependency "motion-support" # inflectors
  spec.add_runtime_dependency "sugarcube" # nsdate helpers

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  # NOTE: testing dependencies are loaded in the Rakefile
  spec.add_development_dependency "motion-spec" # RSpec-like Bacon replacement
  spec.add_development_dependency "motion-stump" # stubbing and mocking
  spec.add_development_dependency "webstub" # http stubbing
end
