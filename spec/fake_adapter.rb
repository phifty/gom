
class FakeAdapter < GOM::Storage::Adapter

  STORE = {
    "house_1" => {
      :class => "House",
      :properties => {
        "number" => 5
      }
    }
  }.freeze

  def fetch(id)
    STORE[id]
  end

  def store(object_hash)
    "house_2"
  end

end

GOM::Storage::Adapter.register :fake_adapter, FakeAdapter
