# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'docbert/version'

Gem::Specification.new do |s|
  s.name          = "docbert"
  s.version       = Docbert::VERSION
  s.authors       = ["David Leal"]
  s.email         = ["dleal@mojotech.com"]
  s.homepage      = "https://github.com/mojotech/docbert"
  s.summary       = "A tool to help write literate cucumber"
  s.description   = "See https://github.com/mojotech/docbert/features/index.feature.md"

  s.files         = `git ls-files app lib`.split("\n")
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'

  s.add_dependency 'kramdown', '>= 1.0.0'
  s.add_dependency 'cucumber'

  s.add_development_dependency 'rspec-expectations'
end
