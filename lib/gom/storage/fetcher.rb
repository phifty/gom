
module GOM

  module Storage

    # Fetches an object from the storage.
    class Fetcher

      attr_accessor :object
      attr_reader :storage_name
      attr_reader :object_id

      def initialize(id, object = nil)
        @id, @object = id, object
        @storage_name, @object_id = @id.split ":"
      end

      def perform
        select_adapter
        fetch_object_hash
        initialize_object unless @object
        inject_object_hash
      end

      private

      def select_adapter
        @adapter = GOM::Storage::Configuration[@storage_name].adapter
      end

      def fetch_object_hash
        @object_hash = @adapter.fetch @object_id
        @object_hash[:id] = @id
      end

      def initialize_object
        @object = Object.const_get(@object_hash[:class].to_sym).new
      end

      def inject_object_hash
        injector = GOM::Object::Injector.new @object, @object_hash
        injector.perform
        @object = injector.object
      end

    end

  end

end
