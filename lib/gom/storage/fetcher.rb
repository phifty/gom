
module GOM

  module Storage

    # Fetches an object from the storage.
    class Fetcher

      attr_accessor :id

      def initialize(id)
        @id = id
      end

      def object
        fetch_object_hash
        return unless has_object_hash?
        build_object
        @object
      end

      private

      def fetch_object_hash
        @object_hash = @id ? adapter.fetch(@id.object_id) : nil
      end

      def has_object_hash?
        !!@object_hash
      end

      def build_object
        @object = GOM::Object::CachedBuilder.new(@object_hash, @id).object
      end

      def adapter
        @adapter ||= GOM::Storage::Configuration[@id.storage_name].adapter
      end

    end

  end

end
