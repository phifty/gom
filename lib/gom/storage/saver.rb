
module GOM

  module Storage

    # Stores an object to the storage.
    class Saver

      attr_reader :id
      attr_reader :object
      attr_reader :storage_name
      attr_reader :object_id

      def initialize(storage_name, object)
        @storage_name, @object = storage_name, object
      end

      def perform
        select_adapter
        inspect_object
        store_object_hash
        write_object_id
      end

      private

      def select_adapter
        @adapter = GOM::Storage::Configuration[@storage_name].adapter
      end

      def inspect_object
        inspector = GOM::Object::Inspector.new @object
        inspector.perform
        @object_hash = inspector.object_hash
      end

      def store_object_hash
        @object_id = @adapter.store @object_hash
        @id = "#{@storage_name}:#{@object_id}"
      end

      def write_object_id
        injector = GOM::Object::Injector.new @object
        injector.write_id @id
      end

    end

  end

end
