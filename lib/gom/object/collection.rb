
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

      def respond_to?(method_name)
        (@object_proxies || @rows).respond_to?(method_name)
      end

      def method_missing(method_name, *arguments, &block)
        load unless (@object_proxies || @rows)
        (@object_proxies || @rows).send method_name, *arguments, &block
      end

      private

      def load
        if fetcher_has_drafts?
          load_object_proxies_from_drafts
        elsif fetcher_has_ids?
          load_object_proxies_from_ids
        elsif fetcher_has_rows?
          load_rows
        else
          raise NotImplementedError, "the collection fetcher doesn't provide drafts, ids nor rows."
        end
      end

      def fetcher_has_drafts?
        @fetcher.respond_to?(:drafts) && @fetcher.drafts
      end

      def load_object_proxies_from_drafts
        @object_proxies = @fetcher.drafts.map do |draft|
          GOM::Object::Proxy.new GOM::Object::CachedBuilder.new(draft).object
        end
      end

      def fetcher_has_ids?
        @fetcher.respond_to?(:ids) && @fetcher.ids
      end

      def load_object_proxies_from_ids
        @object_proxies = @fetcher.ids.map do |id|
          GOM::Object::Proxy.new id
        end
      end

      def fetcher_has_rows?
        @fetcher.respond_to?(:rows) && @fetcher.rows
      end

      def load_rows
        @rows = @fetcher.rows
      end

    end

  end

end
