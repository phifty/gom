
module GOM

  module Storage

    # Removes an object from the storage.
    class Remover

      attr_reader :object
      attr_reader :id
      attr_reader :storage_name
      attr_reader :object_id

      def initialize(object_or_id)
        @object, @id = object_or_id.is_a?(String) ?
          [ nil, object_or_id ] :
          [ object_or_id, object_or_id.instance_variable_get(:@id) ]
        @storage_name, @object_id = @id.split ":"
      end

      def perform
        select_adapter
        remove_object
        set_object_id_to_nil
      end

      private

      def select_adapter
        @adapter = GOM::Storage::Configuration[@storage_name].adapter
      end

      def remove_object
        @adapter.remove @object_id
      end

      def set_object_id_to_nil
        @object.instance_variable_set :@id, nil
      end

    end

  end

end
