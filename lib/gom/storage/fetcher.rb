
# Fetches a draft from the storage adapter and uses the cached builder to build an object from it.
class GOM::Storage::Fetcher

  attr_accessor :id

  def initialize(id)
    @id = id
  end

  def object
    fetch_draft
    return nil unless has_draft?
    build_object
    @object
  end

  private

  def fetch_draft
    @draft = @id ? adapter.fetch(@id.object_id) : nil
  end

  def has_draft?
    !!@draft
  end

  def build_object
    @object = GOM::Object::CachedBuilder.new(@draft, @id.storage_name).object
  end

  def adapter
    @adapter ||= GOM::Storage::Configuration[@id.storage_name].adapter
  end

end
