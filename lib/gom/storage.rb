
module GOM

  module Storage

    autoload :Configuration, File.join(File.dirname(__FILE__), "storage", "configuration")
    autoload :Adapter, File.join(File.dirname(__FILE__), "storage", "adapter")
    autoload :Fetcher, File.join(File.dirname(__FILE__), "storage", "fetcher")

    def self.fetch(id, object = nil)
      fetcher = Fetcher.new id, object
      fetcher.perform
      fetcher.object
    end

  end

end
