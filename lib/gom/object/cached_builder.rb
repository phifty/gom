
# Build an object out of the given draft using Builder. Uses the object-id mapping
# for caching the results.
class GOM::Object::CachedBuilder

  attr_accessor :draft
  attr_accessor :storage_name

  def initialize(draft, storage_name)
    @draft, @storage_name = draft, storage_name
  end

  def object
    initialize_id
    check_mapping
    build_object
    set_mapping
    @object
  end

  private

  def initialize_id
    @id = GOM::Object::Id.new @storage_name, @draft.id
  end

  def check_mapping
    @object = GOM::Object::Mapping.object_by_id @id
  end

  def build_object
    @object = GOM::Object::Builder.new(@draft, @object).object
  end

  def set_mapping
    GOM::Object::Mapping.put @object, @id
  end

end
