# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require "Thin_Upstart/version"

Gem::Specification.new do |s|
  s.name        = "Thin_Upstart"
  s.version     = Thin_Upstart::VERSION
  s.authors     = ["da99"]
  s.email       = ["i-hate-spam-45671204@mailinator.com"]
  s.homepage    = "https://github.com/da99/Thin_Upstart"
  s.summary     = %q{Generate Upstart conf files for your Thin apps.}
  s.description = %q{
    Generates Upstart conf files for your Thin apps.
    Uses Mustache templates for customization.
  }

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'bacon'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'Bacon_Colored'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'Exit_Zero'
  
  # Specify any dependencies here; for example:
  s.add_runtime_dependency 'mustache'
  s.add_runtime_dependency 'trollop'
end
