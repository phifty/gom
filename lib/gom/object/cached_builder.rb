
module GOM

  module Object

    # Build an object out of the given object hash using Builder. Uses the object-id mapping
    # for caching the results.
    class CachedBuilder

      attr_accessor :object_hash
      attr_accessor :id

      def initialize(object_hash, id = nil)
        @object_hash, @id = object_hash, id
      end

      def object
        check_mapping
        build_object
        set_mapping
        @object
      end

      private

      def check_mapping
        @object = GOM::Object::Mapping.object_by_id @id
      end

      def build_object
        @object = GOM::Object::Builder.new(@object_hash, @object).object
      end

      def set_mapping
        GOM::Object::Mapping.put @object, @id
      end

    end

  end

end
