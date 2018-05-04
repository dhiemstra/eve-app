$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "eve_app/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "eve_app"
  s.version     = EveApp::VERSION
  s.authors     = ["Danny Hiemstra"]
  s.email       = ["dannyhiemstra@gmail.com"]
  s.homepage    = "http://www.evebuddy.net"
  s.summary     = "EveApp API"
  s.description = "Basic models for the EveSDE data"
  s.license     = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency "rails", "~> 5"
  s.add_dependency "multi_json"
  s.add_dependency "sshkit"
  s.add_dependency "kaminari"
  s.add_dependency "rest-client"
  s.add_dependency "active_model_serializers"

  s.add_development_dependency "rake"
  s.add_development_dependency "sqlite3"
end
