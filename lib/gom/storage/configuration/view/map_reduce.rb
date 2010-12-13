
module GOM

  module Storage

    class Configuration

      module View

        # :nodoc:
        class MapReduce

          attr_accessor :language
          attr_accessor :map
          attr_accessor :reduce

          def initialize(language, map, reduce)
            @language, @map, @reduce = language, map, reduce
          end

        end

      end

    end

  end

end
