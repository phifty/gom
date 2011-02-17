
# Removes an object from the storage.
class GOM::Storage::Remover

  attr_reader :object
  attr_reader :id

  def initialize(object_or_id)
    @object, @id = object_or_id.is_a?(GOM::Object::Id) ?
      [ nil, object_or_id ] :
      [ object_or_id, nil ]
  end

  def perform
    check_mapping
    remove_object
    remove_mapping
  end

  private

  def check_mapping
    @id ||= GOM::Object::Mapping.id_by_object @object
    raise ArgumentError, "No id existing for the given object!" unless @id
  end

  def remove_object
    adapter.remove @id.object_id
  end

  def remove_mapping
    GOM::Object::Mapping.remove_by_object @object
  end

  def adapter
    @adapter ||= GOM::Storage::Configuration[@id.storage_name].adapter
  end

end
