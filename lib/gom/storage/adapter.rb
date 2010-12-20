
module GOM

  module Storage

    # Base class for a storage adapter
    class Adapter

      # If a view could not be found, this error is raised.
      class ViewNotFoundError < StandardError; end

      attr_reader :configuration

      def initialize(configuration)
        @configuration = configuration
      end

      def setup(*arguments)
        not_implemented "setup"
      end

      def fetch(*arguments)
        not_implemented "fetch"
      end

      def store(*arguments)
        not_implemented "store"
      end

      def remove(*arguments)
        not_implemented "remove"
      end

      def collection(*arguments)
        not_implemented "collection"
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
        @adapter_classes ||= { }
        @adapter_classes[id.to_sym]
      end

    end

  end

end
