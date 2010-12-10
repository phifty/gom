
module GOM

  module Storage

    module Collection

      # A fetcher base class for collections.
      class Fetcher

        def objects_or_ids
          raise NotImplementedError, "the objects method has to be defined by the adapter"
        end

      end

    end

  end

end
