
module GOM

  module Object

    # Inspect an object and returns it's class and it's properties
    class Inspector

      attr_accessor :object

      def initialize(object)
        @object = object
      end

      def draft
        initialize_draft
        set_class
        set_properties
        set_relations
        @draft
      end

      private

      def initialize_draft
        @draft = Draft.new
      end

      def set_class
        @draft.class_name = @object.class.to_s
      end

      def set_properties
        properties = { }
        read_instance_variables do |key, value|
          properties[key] = value if self.class.property_value?(value)
        end
        @draft.properties = properties
      end

      def set_relations
        relations = { }
        read_instance_variables do |key, value|
          relations[key] = value if self.class.relation_value?(value)
        end
        @draft.relations = relations
      end

      def read_instance_variables
        @object.instance_variables.each do |name|
          key = name.to_s.sub(/^@/, "").to_sym
          value = @object.instance_variable_get name
          yield key, value
        end
      end

      def self.property_value?(value)
        !relation_value?(value)
      end

      def self.relation_value?(value)
        value.is_a?(GOM::Object::Proxy)
      end

    end

  end

end
