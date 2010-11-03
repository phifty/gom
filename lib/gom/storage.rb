
module GOM

  module Storage

    autoload :Configuration, File.join(File.dirname(__FILE__), "storage", "configuration")
    autoload :Adapter, File.join(File.dirname(__FILE__), "storage", "adapter")
    autoload :Fetcher, File.join(File.dirname(__FILE__), "storage", "fetcher")
    autoload :Saver, File.join(File.dirname(__FILE__), "storage", "saver")
    autoload :Remover, File.join(File.dirname(__FILE__), "storage", "remover")

    def self.fetch(id, object = nil)
      fetcher = Fetcher.new id, object
      fetcher.perform
      fetcher.object
    end

    def self.store(storage_name, object)
      saver = Saver.new storage_name, object
      saver.perform
      saver.id
    end

    def self.remove(object_or_id)
      remover = Remover.new object_or_id
      remover.perform
    end

  end

end
