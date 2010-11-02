
module GOM

  module Storage

    autoload :Configuration, File.join(File.dirname(__FILE__), "storage", "configuration")
    autoload :Adapter, File.join(File.dirname(__FILE__), "storage", "adapter")

    def self.fetch(id, object = nil)
      storage_name, object_id = id.split ":"
      adapter = Configuration[storage_name].adapter
      hash = adapter.fetch object_id
      object = Object.const_get(hash[:class].to_sym).new unless object
      object.instance_variable_set :@id, id
      hash[:properties].each do |key, value|
        object.instance_variable_set :"@#{key}", value
      end
      object
    end

  end

end
