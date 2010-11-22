require File.join(File.dirname(__FILE__), "spec", "acceptance", "adapter_with_stateful_storage")

module GOM

  autoload :Object, File.join(File.dirname(__FILE__), "gom", "object")
  autoload :Storage, File.join(File.dirname(__FILE__), "gom", "storage")

end
