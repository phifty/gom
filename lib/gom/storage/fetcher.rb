
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
        check_mapping
        initialize_object
        set_mapping
        @object
      end

      private

      def fetch_object_hash
        @object_hash = @id ? adapter.fetch(@id.object_id) : nil
      end

      def has_object_hash?
        !!@object_hash
      end

      def check_mapping
        @object = GOM::Object::Mapping.object_by_id @id
      end

      def initialize_object
        @object = GOM::Object::Builder.new(@object_hash, @object).object
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
