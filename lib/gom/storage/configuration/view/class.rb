
module GOM

  module Storage

    # Stores all information to configure a storage.
    class Configuration

      module View

        # Contains all the parameters for a class view.
        class Class

          attr_accessor :class_name

          def initialize(class_name)
            @class_name = class_name
          end

        end

      end

    end

  end

end
