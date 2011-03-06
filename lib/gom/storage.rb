
module GOM::Storage

  autoload :Adapter, File.join(File.dirname(__FILE__), "storage", "adapter")
  autoload :Configuration, File.join(File.dirname(__FILE__), "storage", "configuration")
  autoload :Counter, File.join(File.dirname(__FILE__), "storage", "counter")
  autoload :Fetcher, File.join(File.dirname(__FILE__), "storage", "fetcher")
  autoload :Remover, File.join(File.dirname(__FILE__), "storage", "remover")
  autoload :Saver, File.join(File.dirname(__FILE__), "storage", "saver")

  # This error can be thrown by the setup method if the given adapter name isn't registered
  class AdapterNotFoundError < StandardError; end

  # This error can be thrown by an adapter if it's doesn't support write operations
  class ReadOnlyError < StandardError; end

  def self.setup
    GOM::Object::Mapping.clear!
    Configuration.setup_all
  end

  def self.teardown
    Configuration.teardown_all
  end

  def self.fetch(id_string)
    id = id_string.is_a?(String) ? GOM::Object::Id.new(id_string) : nil
    Fetcher.new(id).object
  end

  def self.store(object, storage_name = nil)
    Saver.new(object, storage_name).perform
  end

  def self.remove(object_or_id)
    object_or_id = GOM::Object::Id.new object_or_id if object_or_id.is_a?(String)
    Remover.new(object_or_id).perform
  end

  def self.count(storage_name)
    Counter.new(storage_name).perform
  end

  def self.collection(storage_name, *arguments)
    Configuration[storage_name].adapter.collection *arguments
  end

end
