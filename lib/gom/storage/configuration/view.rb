
module GOM

  module Storage

    class Configuration

      module View

        autoload :Class, File.join(File.dirname(__FILE__), "view", "class")
        autoload :MapReduce, File.join(File.dirname(__FILE__), "view", "map_reduce")

      end

    end

  end

end
