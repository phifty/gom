require 'rspec'

require File.join(File.dirname(__FILE__), "spec", "acceptance", "adapter_that_needs_setup")
require File.join(File.dirname(__FILE__), "spec", "acceptance", "adapter_with_stateful_storage")
require File.join(File.dirname(__FILE__), "spec", "acceptance", "read_only_adapter_with_stateless_storage")

module GOM::Spec

  autoload :Object, File.join(File.dirname(__FILE__), "spec", "object")

end
