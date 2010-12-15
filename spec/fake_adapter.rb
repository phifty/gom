
class FakeAdapter < GOM::Storage::Adapter

  class ClassCollectionFetcher

    def initialize(store, storage_name, class_name)
      @store, @storage_name, @class_name = store, storage_name, class_name
    end

    def drafts
      drafts = [ ]
      @store.each do |object_id, draft|
        drafts << draft if draft.class_name == @class_name
      end
      drafts
    end

  end

  def setup
    @store = { }
  end

  def fetch(id)
    result = @store[id]
    result
  end

  def store(draft)
    # store relations
    draft.relations.each do |key, related_object_proxy|
      GOM::Storage.store related_object_proxy.object, configuration.name
      id = GOM::Object::Mapping.id_by_object related_object_proxy.object
      draft.relations[key] = GOM::Object::Proxy.new id
    end

    # may generate an id
    object_id = draft.id || next_id

    # store the draft
    @store[object_id] = draft

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
