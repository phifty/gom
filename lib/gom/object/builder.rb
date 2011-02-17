
# Build an object out of the given draft.
class GOM::Object::Builder

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
    set_class
    arity = [ @klass.method(:new).arity, 0 ].max
    @object = @klass.new *([ nil ] * arity)
  end

  def set_class
    names = @draft.class_name.split "::"
    names.shift if names.empty? || names.first.empty?

    @klass = ::Object
    names.each do |name|
      @klass = @klass.const_defined?(name) ? @klass.const_get(name) : @klass.const_missing(name)
    end
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
