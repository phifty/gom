require 'rubygems'
gem 'rspec'
require 'spec'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'spec/rake/spectask'

task :default => :spec

specification = Gem::Specification.new do |specification|
  specification.name              = "gom"
  specification.version           = "0.0.1"
  specification.date              = "2010-10-27"

  specification.authors           = [ "Philipp Bruell" ]
  specification.email             = "b.phifty@gmail.com"
  specification.homepage          = "http://github.com/phifty/gom"
  specification.rubyforge_project = "gom"

  specification.summary           = ""
  specification.description       = ""

  specification.has_rdoc          = true
  specification.files             = [ "README.rdoc", "LICENSE", "Rakefile" ] + Dir["lib/**/*"] + Dir["spec/**/*"]
  specification.extra_rdoc_files  = [ "README.rdoc" ]
  specification.require_path      = "lib"

  specification.test_files        = Dir["spec/**/*_spec.rb"]
end

Rake::GemPackageTask.new(specification) do |package|
  package.gem_spec = specification
end

desc "Generate the rdoc"
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_files.add [ "README.rdoc", "lib/**/*.rb" ]
  rdoc.main  = "README.rdoc"
  rdoc.title = ""
end

desc "Run all specs in spec directory"
Spec::Rake::SpecTask.new do |task|
  task.spec_files = FileList["spec/lib/**/*_spec.rb"]
end

namespace :spec do

  desc "Run all integration specs in spec/acceptance directory"
  Spec::Rake::SpecTask.new(:acceptance) do |task|
    task.spec_files = FileList["spec/acceptance/**/*_spec.rb"]
  end

end
