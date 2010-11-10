require File.join(File.dirname(__FILE__), "adapter")
require 'yaml'

module GOM

  module Storage

    # Stores all information to configure a storage
    class Configuration

      attr_reader :name

      def initialize(name, hash)
        @name, @hash = name, { }
        hash.each{ |key, value| @hash[key.to_sym] = value }
      end

      def adapter
        @adapter ||= self.adapter_class.new self
      end

      def adapter_class
        @adapter_class ||= Adapter[@hash[:adapter]]
      end

      def [](key)
        @hash[key.to_sym]
      end

      def self.read(file_name)
        @configurations = { }
        YAML::load_file(file_name).each do |name, values|
          @configurations[name.to_sym] = self.new name, values
        end
      end

      def self.[](name)
        @configurations ||= { }
        @configurations[name.to_sym]
      end

      def self.default
        @configurations ||= { }
        @configurations.values.first || raise(StandardError, "No storage configuration loaded!")
      end

    end

  end

end
