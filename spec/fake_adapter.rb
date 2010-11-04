
class FakeAdapter < GOM::Storage::Adapter

  STORE = {
    "object_1" => {
      :class => "Object",
      :properties => {
        "number" => 5
      }
    }
  }.freeze

  def fetch(id)
    STORE[id]
  end

  def store(object_hash)
    "object_1"
  end

  def remove(id)

  end

end

GOM::Storage::Adapter.register :fake_adapter, FakeAdapter
