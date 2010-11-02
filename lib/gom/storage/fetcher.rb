
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
        fetch_result
        initialize_object unless @object
        inject_result
      end

      private

      def select_adapter
        @adapter = GOM::Storage::Configuration[@storage_name].adapter
      end

      def fetch_result
        @result = @adapter.fetch @object_id
        @result[:id] = @id
      end

      def initialize_object
        @object = Object.const_get(@result[:class].to_sym).new
      end

      def inject_result
        injector = GOM::Object::Injector.new @object, @result
        injector.perform
        @object = injector.object
      end

    end

  end

end
