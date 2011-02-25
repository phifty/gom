
# Value class for object ids.
class GOM::Object::Id

  attr_accessor :storage_name
  attr_accessor :object_id

  def initialize(id_or_storage_name = nil, object_id = nil)
    @storage_name, @object_id = id_or_storage_name.is_a?(String) ?
      (object_id.is_a?(String) ? [ id_or_storage_name, object_id ] : id_or_storage_name.split(":")) :
      [ nil, nil ]
  end

  def ==(other)
    other.is_a?(self.class) && @storage_name == other.storage_name && @object_id == other.object_id
  end

  def to_s
    "#{@storage_name}:#{@object_id}"
  end

end
