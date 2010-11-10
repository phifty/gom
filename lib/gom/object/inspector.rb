
module GOM

  module Object

    # Inspect an object and returns it's class and it's properties
    class Inspector

      attr_reader :object
      attr_reader :object_hash

      def initialize(object)
        @object = object
        @object_hash = { }
      end

      def perform
        read_class
        read_properties
        read_relations
      end

      private

      def read_class
        @object_hash[:class] = @object.class.to_s
      end

      def read_properties
        @object_hash[:properties] = { }
        read_instance_variables do |key, value|
          @object_hash[:properties][key] = value unless value.is_a?(GOM::Object::Proxy)
        end
      end

      def read_relations
        @object_hash[:relations] = { }
        read_instance_variables do |key, value|
          @object_hash[:relations][key] = value if value.is_a?(GOM::Object::Proxy)
        end
      end

      def read_instance_variables
        @object.instance_variables.each do |name|
          key = name.to_s.sub(/^@/, "").to_sym
          value = @object.instance_variable_get name
          yield key, value
        end
      end

    end

  end

end
