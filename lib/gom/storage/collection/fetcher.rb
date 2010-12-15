
module GOM

  module Storage

    module Collection

      # A fetcher base class for collections.
      class Fetcher

        def object_hashes
          raise NotImplementedError, "the object_hashes method has to be defined by the collection fetcher"
        end

        def ids
          raise NotImplementedError, "the ids method has to be defined by the collection fetcher"
        end

      end

    end

  end

end
