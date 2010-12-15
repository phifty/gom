
module GOM

  module Object

    # A draft for an object
    class Draft

      attr_accessor :id
      attr_accessor :class_name
      attr_writer :properties
      attr_writer :relations

      def initialize(id = nil, class_name = nil, properties = { }, relations = { })
        @id, @class_name, @properties, @relations = id, class_name, properties, relations
      end

      def properties
        @properties || { }
      end

      def relations
        @relations || { }
      end

      def ==(other)
        id == other.id && class_name == other.class_name && properties == other.properties && relations == other.relations
      end

    end

  end

end
