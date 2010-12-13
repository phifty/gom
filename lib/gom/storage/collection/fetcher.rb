
module GOM

  module Storage

    module Collection

      # A fetcher base class for collections.
      class Fetcher

        def objects_or_ids
          raise NotImplementedError, "the objects_or_ids method has to be defined by the collection fetcher"
        end

      end

    end

  end

end
