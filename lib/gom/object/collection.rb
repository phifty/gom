
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
        @object_proxies ||= begin
          if fetcher_has_drafts?
            object_proxies_from_drafts
          elsif fetcher_has_ids?
            object_proxies_from_ids
          else
            raise NotImplementedError, "the collection fetcher doesn't provide drafts nor ids."
          end
        end
      end

      def fetcher_has_drafts?
        @fetcher.respond_to? :drafts
      end

      def object_proxies_from_drafts
        @fetcher.drafts.map do |draft|
          GOM::Object::Proxy.new GOM::Object::CachedBuilder.new(draft).object
        end
      end

      def fetcher_has_ids?
        @fetcher.respond_to? :ids
      end

      def object_proxies_from_ids
        @fetcher.ids.map do |id|
          GOM::Object::Proxy.new id
        end
      end

    end

  end

end
