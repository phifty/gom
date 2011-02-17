
# Base class for a storage adapter
class GOM::Storage::Adapter

  # If the adapter is used without a setup, this error is may raised.
  class NoSetupError < StandardError; end

  # If a view could not be found, this error is raised.
  class ViewNotFoundError < StandardError; end

  attr_reader :configuration

  def initialize(configuration)
    @configuration = configuration
  end

  [ :setup, :teardown, :fetch, :store, :remove, :collection ].each do |key|

    define_method key do |*arguments|
      not_implemented key
    end

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
