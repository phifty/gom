
module GOM

  module Object

    # The proxy that fetches an object if it's needed and simply passes method calls to it.
    class Proxy

      def initialize(object_or_id)
        @object, @id = object_or_id.is_a?(GOM::Object::Id) ?
          [ nil, object_or_id ] :
          [ object_or_id, nil ]
      end

      def object
        fetch_object unless @object
        @object
      end

      def method_missing(method_name, *arguments, &block)
        fetch_object unless @object
        @object.send method_name, *arguments, &block
      end

      private

      def fetch_object
        fetcher = GOM::Storage::Fetcher.new @id
        fetcher.perform
        @object = fetcher.object
      end

    end

  end

end
