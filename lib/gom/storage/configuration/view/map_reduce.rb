
module GOM

  module Storage

    # Stores all information to configure a storage.
    class Configuration

      module View

        # Contains all parameters for a map reduce view.
        class MapReduce

          attr_accessor :map
          attr_accessor :reduce

          def initialize(map, reduce)
            @map, @reduce = map, reduce
          end

        end

      end

    end

  end

end
