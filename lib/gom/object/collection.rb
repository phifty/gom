
module GOM

  module Object

    # A class for a collection of objects.
    class Collection

      def initialize(fetcher)
        @fetcher = fetcher
      end

      def total_count
        @fetcher.total_count
      end

      def method_missing(method_name, *arguments, &block)
        load_object_proxies
        @object_proxies.send method_name, *arguments, &block
      end

      private

      def load_object_proxies
        @object_proxies ||= @fetcher.objects_or_ids.map{ |object_or_id| GOM::Object::Proxy.new object_or_id }
      end

    end

  end

end
