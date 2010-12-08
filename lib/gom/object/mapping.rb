
module GOM

  module Object

    # Provides a mapping between objects and ids
    class Mapping

      def initialize
        @map = { }
      end

      def put(object, id)
        @map[object] = id
      end

      def object_by_id(id)
        @map.respond_to?(:key) ? @map.key(id) : @map.index(id)
      end

      def id_by_object(object)
        @map[object]
      end

      def remove_by_id(id)
        @map.delete object_by_id(id)
      end

      def remove_by_object(object)
        @map.delete object
      end

      def self.singleton
        @mapping ||= self.new
      end

      def self.put(object, id)
        self.singleton.put object, id
      end

      def self.object_by_id(id)
        self.singleton.object_by_id id
      end

      def self.id_by_object(object)
        self.singleton.id_by_object object
      end

      def self.remove_by_id(id)
        self.singleton.remove_by_id id
      end

      def self.remove_by_object(object)
        self.singleton.remove_by_object object
      end

    end

  end

end
