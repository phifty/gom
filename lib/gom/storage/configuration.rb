require File.join(File.dirname(__FILE__), "adapter")
require 'yaml'

module GOM

  module Storage

    # Stores all information to configure a storage.
    class Configuration

      autoload :View, File.join(File.dirname(__FILE__), "configuration", "view")

      attr_reader :name
      attr_reader :hash

      def initialize(name, hash)
        @name, @hash = name, { }
        hash.each{ |key, value| @hash[key.to_sym] = value }
      end

      def setup
        adapter.setup
      end

      def teardown
        adapter.teardown
        clear_adapter
      end

      def adapter
        @adapter ||= adapter_class.new self
      end

      def adapter_class
        @adapter_class ||= Adapter[@hash[:adapter]] || raise(GOM::Storage::AdapterNotFoundError)
      end

      def [](key)
        @hash[key.to_sym]
      end

      def values_at(*arguments)
        arguments.map{ |argument| self[argument] }
      end

      def views
        @views ||= begin
          result = { }
          (self["views"] || { }).each do |name, hash|
            result[name.to_sym] = self.class.view hash
          end
          result
        end
      end

      private

      def clear_adapter
        @adapter, @adapter_class = nil, nil        
      end

      def self.view(hash)
        type = hash["type"]
        method_name = :"#{type}_view"
        raise NotImplementedError, "the view type '#{type}' doesn't exists" unless self.respond_to?(method_name)
        self.send method_name, hash
      end

      def self.class_view(hash)
        View::Class.new hash["class"]
      end

      def self.map_reduce_view(hash)
        View::MapReduce.new *hash.values_at("map", "reduce")
      end

      def self.read(file_name)
        @configurations = { }
        YAML::load_file(file_name).each do |name, values|
          @configurations[name.to_sym] = self.new name, values
        end
      end

      def self.setup_all
        @configurations.values.each do |configuration|
          configuration.setup
        end
      end

      def self.teardown_all
        @configurations.values.each do |configuration|
          configuration.teardown
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
