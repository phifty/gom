
# A draft for an object
class GOM::Object::Draft

  attr_accessor :object_id
  attr_accessor :class_name
  attr_writer :properties
  attr_writer :relations

  def initialize(object_id = nil, class_name = nil, properties = { }, relations = { })
    @object_id, @class_name, @properties, @relations = object_id, class_name, properties, relations
  end

  def properties
    @properties || { }
  end

  def relations
    @relations || { }
  end

  def ==(other)
    object_id == other.object_id && class_name == other.class_name && properties == other.properties && relations == other.relations
  end

end
