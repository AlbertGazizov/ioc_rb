# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ioc_rb/version'

Gem::Specification.new do |spec|
  spec.name          = "ioc_rb"
  spec.version       = IocRb::VERSION
  spec.authors       = ["Albert Gazizov", "Ruslan Gatiyatov"]
  spec.email         = ["deeper4k@gmail.com", "ruslan.gatiyatov@gmail.com"]
  spec.description   = %q{Inversion of Controll Container}
  spec.summary       = %q{Inversion of Controll Container}
  spec.homepage      = "http://github.com/deeper4k/ioc_rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "activesupport"
end
