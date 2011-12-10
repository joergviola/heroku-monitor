# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "heroku-monitor/version"

Gem::Specification.new do |s|
  s.name        = "heroku-monitor"
  s.version     = Heroku::Command::Monitor::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Joerg Viola"]
  s.email       = ["joerg@joergviola.de"]
  s.homepage    = ""
  s.summary     = %q{Plugin that provides simple monitoring for your heroku app.}
  s.description = %q{Plugin that provides simple monitoring for your heroku app. }

  s.rubyforge_project = "heroku-monitor"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "heroku", "~> 2.0.0"
end
