
module GOM

  module Storage

    # Fetches an object from the storage.
    class Fetcher

      attr_accessor :object
      attr_reader :id

      def initialize(id, object = nil)
        @id, @object = id, object
      end

      def perform
        fetch_object_hash
        return unless has_object_hash?
        initialize_object
        inject_object_hash
        set_mapping
      end

      private

      def fetch_object_hash
        @object_hash = adapter.fetch @id.object_id
      end

      def has_object_hash?
        !!@object_hash
      end

      def initialize_object
        @object = GOM::Object::Mapping.object_by_id @id unless @object
        @object = Object.const_get(@object_hash[:class].to_sym).new unless @object
      end

      def inject_object_hash
        injector = GOM::Object::Injector.new @object, @object_hash
        injector.perform
        @object = injector.object
      end

      def set_mapping
        GOM::Object::Mapping.put @object, @id
      end

      def adapter
        @adapter ||= GOM::Storage::Configuration[@id.storage_name].adapter
      end

    end

  end

end
