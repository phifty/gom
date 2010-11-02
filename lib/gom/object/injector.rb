
module GOM

  module Object

    # Injects the given properties into the given object.s
    class Injector

      attr_reader :object

      def initialize(object, hash)
        @object, @hash = object, hash
      end

      def perform
        @object.instance_variable_set :@id, @hash[:id]
        @hash[:properties].each do |name, value|
          @object.instance_variable_set :"@#{name}", value
        end
      end

    end

  end

end
