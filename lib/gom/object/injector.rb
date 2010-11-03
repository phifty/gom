
module GOM

  module Object

    # Injects the given properties into the given object.s
    class Injector

      attr_reader :object

      def initialize(object, object_hash = nil)
        @object, @object_hash = object, (object_hash || { })
      end

      def perform
        write_id
        write_properties
      end

      def clear_id
        @object.instance_variable_set :@id, nil
      end

      def write_id(id = nil)
        @object.instance_variable_set :@id, (id || @object_hash[:id])
      end

      private

      def write_properties
        @object_hash[:properties].each do |name, value|
          @object.instance_variable_set :"@#{name}", value
        end
      end

    end

  end

end
