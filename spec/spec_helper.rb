require 'rubygems'
gem 'rspec', '>= 2'
require 'rspec'

require File.expand_path(File.join(File.dirname(__FILE__), "..", "lib", "gom"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "lib", "gom", "spec"))
require File.join(File.dirname(__FILE__), "fake_adapter")
require File.join(File.dirname(__FILE__), "storage_configuration")
