
module GOM

  module Object

    # Build an object out of the given draft.
    class Builder

      attr_accessor :draft
      attr_writer :object

      def initialize(draft, object = nil)
        @draft, @object = draft, object
      end

      def object
        initialize_object unless @object
        set_properties
        set_relations
        @object
      end

      private

      def initialize_object
        klass = Object.const_get @draft.class_name
        arity = [ klass.method(:new).arity, 0 ].max
        @object = klass.new *([ nil ] * arity)
      end

      def set_properties
        @draft.properties.each do |name, value|
          @object.instance_variable_set :"@#{name}", value
        end
      end

      def set_relations
        @draft.relations.each do |name, value|
          @object.instance_variable_set :"@#{name}", value
        end
      end

    end

  end

end
