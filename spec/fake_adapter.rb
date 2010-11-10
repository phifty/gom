
class FakeAdapter < GOM::Storage::Adapter

  STORE = { }

  def fetch(id)
    STORE[id]
  end

  def store(object_hash)
    # store relations
    (object_hash[:relations] || { }).each do |key, related_object_proxy|
      GOM::Storage.store related_object_proxy.object, configuration.name
      id = GOM::Object::Mapping.id_by_object related_object_proxy.object
      object_hash[:relations][key] = GOM::Object::Proxy.new id
    end

    # may generate an id
    object_id = object_hash[:id] || "object_#{STORE.size + 1}"

    # store the object hash
    STORE[object_id] = object_hash

    object_id
  end

  def remove(id)
    STORE.delete id
  end

end

GOM::Storage::Adapter.register :fake_adapter, FakeAdapter
