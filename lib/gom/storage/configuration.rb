require File.join(File.dirname(__FILE__), "adapter")
require 'yaml'

module GOM

  module Storage

    # Stores all information to configure a storage
    class Configuration

      attr_reader :adapter_class

      def initialize(values)
        @adapter_class = Adapter[values["adapter"]]
      end

      def adapter
        @adapter ||= @adapter_class.new self
      end

      def self.read(file_name)
        @configurations = { }
        YAML::load_file(file_name).each do |name, values|
          @configurations[name.to_sym] = self.new values
        end
      end

      def self.[](name)
        @configurations[name.to_sym]
      end

    end

  end

end
