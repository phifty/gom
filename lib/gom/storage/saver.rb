
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
        select_adapter
        inspect_object
        store_object_hash
        set_mapping
      end

      private

      def check_mapping
        @id = GOM::Object::Mapping.id_by_object @object
        if @id
          storage_name, @object_id = @id.split ":"
          @storage_name ||= storage_name
        end
      end

      def select_adapter
        @adapter = (@storage_name ?
          GOM::Storage::Configuration[@storage_name] :
          GOM::Storage::Configuration.default
        ).adapter
      end

      def inspect_object
        inspector = GOM::Object::Inspector.new @object
        inspector.perform
        @object_hash = inspector.object_hash
        @object_hash[:id] = @object_id if @object_id
      end

      def store_object_hash
        @object_id = @adapter.store @object_hash
        @id = "#{@storage_name}:#{@object_id}"
      end

      def set_mapping
        GOM::Object::Mapping.put @object, @id
      end

    end

  end

end
