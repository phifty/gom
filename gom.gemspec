# encoding: utf-8

Gem::Specification.new do |specification|
  specification.name              = "gom"
  specification.version           = "0.4.0"
  specification.date              = "2011-05-10"

  specification.authors           = [ "Philipp Brüll" ]
  specification.email             = "b.phifty@gmail.com"
  specification.homepage          = "http://github.com/phifty/gom"
  specification.rubyforge_project = "gom"

  specification.summary           = "General Object Mapper - maps any ruby object to different kinds of storage engines and vice versa."
  specification.description       = "Core package of the General Object Mapper."

  specification.has_rdoc          = true
  specification.files             = [ "README.rdoc", "LICENSE", "Rakefile" ] + Dir["lib/**/*"] + Dir["spec/**/*"]
  specification.extra_rdoc_files  = [ "README.rdoc" ]
  specification.require_path      = "lib"

  specification.test_files        = Dir["spec/**/*_spec.rb"]

  specification.add_dependency "configure", ">= 0.3.0"

  specification.add_development_dependency "rspec", ">= 2"
  specification.add_development_dependency "reek", ">= 1.2"
end
