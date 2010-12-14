
module GOM

  module Object

    # Build an object out of the given object hash.
    class Builder

      attr_accessor :object_hash
      attr_writer :object

      def initialize(object_hash, object = nil)
        @object_hash, @object = object_hash, object
      end

      def object
        initialize_object unless @object
        set_properties
        set_relations
        @object
      end

      private

      def initialize_object
        klass = Object.const_get @object_hash[:class]
        arity = [ klass.method(:new).arity, 0 ].max
        @object = klass.new *([ nil ] * arity)
      end

      def set_properties
        (@object_hash[:properties] || { }).each do |name, value|
          @object.instance_variable_set :"@#{name}", value
        end
      end

      def set_relations
        (@object_hash[:relations] || { }).each do |name, value|
          @object.instance_variable_set :"@#{name}", value
        end
      end

    end

  end

end
