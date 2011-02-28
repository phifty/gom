
# Stores an object to the storage.
class GOM::Storage::Saver

  attr_reader :object
  attr_reader :storage_name

  def initialize(object, storage_name = nil)
    @object, @storage_name = object, storage_name
  end

  def perform
    fetch_id
    update_storage_name
    inspect_object
    store_draft
    store_id
  end

  private

  def fetch_id
    @id = GOM::Object::Mapping.id_by_object @object
  end

  def update_storage_name
    @storage_name ||= @id.storage_name if @id
    @storage_name ||= GOM::Storage::Configuration.default.name
  end

  def inspect_object
    @draft = GOM::Object::Inspector.new(@object).draft
    @draft.object_id = @id.object_id if @id
  end

  def store_draft
    object_id = adapter.store @draft
    @id = GOM::Object::Id.new @storage_name.to_s, object_id
  end

  def store_id
    GOM::Object::Mapping.put @object, @id
  end

  def adapter
    GOM::Storage::Configuration[@storage_name].adapter
  end

end
