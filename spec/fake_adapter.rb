
class FakeAdapter < GOM::Storage::Adapter

  PROPERTIES = {
    "house_1" => {
      "number" => 5
    }
  }.freeze

  def fetch(id)
    {
        :class => "House",
        :properties => PROPERTIES[id]
    }
  end

end

GOM::Storage::Adapter.register :fake_adapter, FakeAdapter
