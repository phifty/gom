
module GOM::Storage::Configuration::View

  autoload :All, File.join(File.dirname(__FILE__), "view", "all")
  autoload :Class, File.join(File.dirname(__FILE__), "view", "class")
  autoload :MapReduce, File.join(File.dirname(__FILE__), "view", "map_reduce")
  autoload :Property, File.join(File.dirname(__FILE__), "view", "property")

end
