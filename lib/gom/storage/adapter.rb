
module GOM

  module Storage

    class Adapter

      def initialize(configuration)
        @configuration = configuration
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
