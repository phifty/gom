
module GOM

  module Object

    # Injects the given properties into the given object.s
    class Injector

      attr_reader :object

      def initialize(object, object_hash)
        @object, @object_hash = object, object_hash
      end

      def perform
        clear_instance_variables
        write_properties
        write_relations
      end

      private

      def clear_instance_variables
        @object.instance_variables.each do |name|
          @object.send :remove_instance_variable, name
        end
      end

      def write_properties
        (@object_hash[:properties] || { }).each do |name, value|
          @object.instance_variable_set :"@#{name}", value
        end
      end

      def write_relations
        (@object_hash[:relations] || { }).each do |name, value|
          @object.instance_variable_set :"@#{name}", value
        end
      end

    end

  end

end
