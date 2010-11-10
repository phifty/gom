
class FakeAdapter < GOM::Storage::Adapter

  STORE = { }

  def fetch(id)
    STORE[id]
  end

  def store(object_hash)
    id = object_hash[:id] || "object_#{STORE.size + 1}"
    STORE[id] = object_hash
    id
  end

  def remove(id)
    STORE.delete id
  end

end

GOM::Storage::Adapter.register :fake_adapter, FakeAdapter
