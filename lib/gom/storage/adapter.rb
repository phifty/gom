
module GOM

  module Storage

    # Base class for a storage adapter
    class Adapter

      def initialize(configuration)
        @configuration = configuration
      end

      def fetch
        not_implemented "fetch"
      end

      def store
        not_implemented "store"
      end

      private

      def not_implemented(method_name)
        raise NotImplementedError, "The adapter has no #{method_name} method implemented"
      end

      def self.register(id, adapter_class)
        @adapter_classes ||= { }
        @adapter_classes[id.to_sym] = adapter_class
      end

      def self.[](id)
        @adapter_classes[id.to_sym]
      end

    end

  end

end
