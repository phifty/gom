
module GOM

  module Storage

    # Fetches an object from the storage.
    class Fetcher

      attr_accessor :id

      def initialize(id)
        @id = id
      end

      def object
        perform
        @object
      end

      private

      def perform
        fetch_object_hash
        return unless has_object_hash?
        initialize_object
        inject_object_hash
        set_mapping
      end

      def fetch_object_hash
        @object_hash = @id ? adapter.fetch(@id.object_id) : nil
      end

      def has_object_hash?
        !!@object_hash
      end

      def initialize_object
        @object = GOM::Object::Mapping.object_by_id @id
        unless @object
          klass = object_class
          arity = klass.method(:new).arity
          @object = klass.new *([ nil ] * arity)
        end
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

      def object_class
        Object.const_get @object_hash[:class]
      end

    end

  end

end
