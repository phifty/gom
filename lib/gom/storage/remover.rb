
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
          [ object_or_id, nil ]
      end

      def perform
        check_mapping
        select_adapter
        remove_object
        remove_mapping
      end

      private

      def select_adapter
        @adapter = GOM::Storage::Configuration[@storage_name].adapter
      end

      def check_mapping
        @id ||= GOM::Object::Mapping.id_by_object @object
        raise ArgumentError, "No id existing for the given object!" unless @id
        @storage_name, @object_id = @id.split ":"
      end

      def remove_object
        @adapter.remove @object_id
      end

      def remove_mapping
        GOM::Object::Mapping.remove_by_object @object
      end

    end

  end

end
