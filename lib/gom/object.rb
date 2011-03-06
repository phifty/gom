
module GOM::Object

  autoload :Builder, File.join(File.dirname(__FILE__), "object", "builder")
  autoload :CachedBuilder, File.join(File.dirname(__FILE__), "object", "cached_builder")
  autoload :Collection, File.join(File.dirname(__FILE__), "object", "collection")
  autoload :Draft, File.join(File.dirname(__FILE__), "object", "draft")
  autoload :Id, File.join(File.dirname(__FILE__), "object", "id")
  autoload :Inspector, File.join(File.dirname(__FILE__), "object", "inspector")
  autoload :Mapping, File.join(File.dirname(__FILE__), "object", "mapping")
  autoload :Proxy, File.join(File.dirname(__FILE__), "object", "proxy")

  def self.id(object)
    id = Mapping.id_by_object object
    id ? id.to_s : nil
  end

  def self.storage_name(object)
    id = Mapping.id_by_object object
    id ? id.storage_name : nil
  end

  def self.reference(object)
    Proxy.new object
  end

end
