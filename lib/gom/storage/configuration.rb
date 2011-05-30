require 'yaml'
require 'configure'

# Stores all information to configure a storage.
class GOM::Storage::Configuration

  autoload :View, File.join(File.dirname(__FILE__), "configuration", "view")

  SCHEMA = Configure::Schema.build{
    only :storage
    nested {
      storage {
        not_nil :name, :adapter
        nested {
          view {
            not_nil :name, :adapter_type
          }
        }
      }
    }
  }.freeze

  attr_reader :hash

  def initialize(hash)
    @hash = { }
    hash.each{ |key, value| @hash[key.to_sym] = value }
  end

  def setup
    adapter.setup
  end

  def teardown
    adapter.teardown
    clear_adapter
  end

  def name
    @hash[:name].to_s
  end

  def adapter
    @adapter ||= adapter_class.new self
  end

  def adapter_class
    @adapter_class ||= GOM::Storage::Adapter[@hash[:adapter]] || raise(GOM::Storage::AdapterNotFoundError)
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
      [ @hash[:view] ].flatten.compact.each do |hash|
        name = hash[:name]
        result[name.to_sym] = self.class.view hash
      end
      result
    end
  end

  private

  def clear_adapter
    @adapter, @adapter_class = nil, nil
  end

  def self.configure(&block)
    @configurations = { }
    configurations = Configure.process SCHEMA, &block
    [ configurations[:storage] ].flatten.compact.each do |hash|
      name = hash[:name]
      @configurations[name.to_sym] = self.new hash
    end
  end

  def self.view(hash)
    type = hash[:adapter_type]
    method_name = :"#{type}_view"
    raise NotImplementedError, "the view type '#{type}' doesn't exists" unless self.respond_to?(method_name)
    self.send method_name, hash
  end

  def self.class_view(hash)
    View::Class.new hash[:model_class]
  end

  def self.map_reduce_view(hash)
    View::MapReduce.new *hash.values_at(:map_function, :reduce_function)
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
