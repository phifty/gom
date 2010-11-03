
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
        read_id
        select_adapter
        remove_object
        write_nil_to_object_id
      end

      private

      def select_adapter
        @adapter = GOM::Storage::Configuration[@storage_name].adapter
      end

      def read_id
        unless @id
          inspector = GOM::Object::Inspector.new @object
          @id = inspector.read_id
        end

        @storage_name, @object_id = @id.split ":"
      end

      def remove_object
        @adapter.remove @object_id
      end

      def write_nil_to_object_id
        injector = GOM::Object::Injector.new @object
        injector.clear_id
      end

    end

  end

end
