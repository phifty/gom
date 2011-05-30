require 'rubygems'
gem 'rspec', '>= 2'
require 'rspec'

require File.expand_path(File.join(File.dirname(__FILE__), "..", "lib", "gom"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "lib", "gom", "spec"))
require File.join(File.dirname(__FILE__), "fake_adapter")

GOM::Storage.configure {
  storage {
    name :test_storage
    adapter :fake_adapter
    view {
      name :test_object_class_view
      adapter_type :class
      model_class Object
    }
    view {
      name :test_map_view
      adapter_type :map_reduce
      map_function "function(document) { }"
      reduce_function "function(key, values) { }"
    }
  }
}
