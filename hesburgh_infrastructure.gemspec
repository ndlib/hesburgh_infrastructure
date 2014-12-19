$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "hesburgh_infrastructure/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "hesburgh_infrastructure"
  s.version     = HesburghInfrastructure::VERSION
  s.authors     = ["Jaron Kennel"]
  s.email       = ["jkennel@nd.edu"]
  s.homepage    = "http://library.nd.edu"
  s.summary     = %q{hesburgh_infrastructure provides deployment and testing configuration for Hesburgh Library
                      Ruby on Rails applications.}
  s.description = %q{hesburgh_infrastructure provides deployment and testing configuration for Hesburgh Library
                      Ruby on Rails applications.}

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE.txt", "Rakefile", "README.md"]

  s.add_dependency "rails"
end
