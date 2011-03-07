
# The proxy that fetches an object if it's needed and simply passes method calls to it.
class GOM::Object::Proxy

  def initialize(object_or_id)
    @object, @id = object_or_id.is_a?(GOM::Object::Id) ?
      [ nil, object_or_id ] :
      [ object_or_id, nil ]
  end

  def object
    fetch_object unless @object
    @object
  end

  def id
    fetch_id unless @id
    @id ? @id.to_s : nil
  end

  def storage_name
    fetch_id unless @id
    @id ? @id.storage_name : nil
  end

  def method_missing(method_name, *arguments, &block)
    fetch_object unless @object
    @object.send method_name, *arguments, &block
  end

  private

  def fetch_object
    @object = GOM::Storage::Fetcher.new(@id).object
  end

  def fetch_id
    @id = GOM::Object::Mapping.id_by_object @object
  end

end
