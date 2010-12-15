
class FakeAdapter < GOM::Storage::Adapter

  class ClassCollectionFetcher

    def initialize(store, storage_name, class_name)
      @store, @storage_name, @class_name = store, storage_name, class_name
    end

    def object_hashes
      object_hashes = [ ]
      @store.each do |object_id, object_hash|
        object_hashes << object_hash if object_hash[:class] == @class_name
      end
      object_hashes
    end

  end

  def setup
    @store = { }
  end

  def fetch(id)
    result = @store[id]
    result
  end

  def store(object_hash)
    # store relations
    (object_hash[:relations] || { }).each do |key, related_object_proxy|
      GOM::Storage.store related_object_proxy.object, configuration.name
      id = GOM::Object::Mapping.id_by_object related_object_proxy.object
      object_hash[:relations][key] = GOM::Object::Proxy.new id
    end

    # may generate an id
    object_id = object_hash[:id] || next_id

    # store the object hash
    @store[object_id] = object_hash

    object_id
  end

  def remove(id)
    @store.delete id
  end

  def collection(view_name)
    case view_name.to_sym
      when :test_object_class_view
        GOM::Object::Collection.new ClassCollectionFetcher.new(@store, configuration.name, "Object")
    end
  end

  private

  def next_id
    "object_#{@store.size + 1}"
  end

end

GOM::Storage::Adapter.register :fake_adapter, FakeAdapter
