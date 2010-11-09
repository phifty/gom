
module GOM

  module Storage

    # Stores an object to the storage.
    class Saver

      attr_reader :object
      attr_reader :storage_name

      def initialize(object, storage_name = nil)
        @object, @storage_name = object, storage_name
      end

      def perform
        check_mapping
        inspect_object
        store_object_hash
        set_mapping
      end

      private

      def check_mapping
        @id = GOM::Object::Mapping.id_by_object @object
        if @id
          @storage_name ||= @id.storage_name
          @object_id = @id.object_id
        end
      end

      def inspect_object
        inspector = GOM::Object::Inspector.new @object
        inspector.perform
        @object_hash = inspector.object_hash
        @object_hash[:id] = @object_id if @object_id
      end

      def store_object_hash
        @object_id = adapter.store @object_hash
        @id = GOM::Object::Id.new @storage_name, @object_id
      end

      def set_mapping
        GOM::Object::Mapping.put @object, @id
      end

      def adapter
        (@storage_name ?
          GOM::Storage::Configuration[@storage_name] :
          GOM::Storage::Configuration.default
        ).adapter
      end
      
    end

  end

end
