
module GOM

  module Storage

    autoload :Configuration, File.join(File.dirname(__FILE__), "storage", "configuration")
    autoload :Adapter, File.join(File.dirname(__FILE__), "storage", "adapter")
    autoload :Fetcher, File.join(File.dirname(__FILE__), "storage", "fetcher")
    autoload :Saver, File.join(File.dirname(__FILE__), "storage", "saver")
    autoload :Remover, File.join(File.dirname(__FILE__), "storage", "remover")

    # This error can be thrown by an adapter if it's doesn't support write operations
    class NoWritePermissionError < StandardError; end

    def self.fetch(id, object = nil)
      fetcher = Fetcher.new id, object
      fetcher.perform
      fetcher.object
    end

    def self.store(object, storage_name = nil)
      saver = Saver.new object, storage_name
      saver.perform
    end

    def self.remove(object_or_id)
      remover = Remover.new object_or_id
      remover.perform
    end

  end

end
