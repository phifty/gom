
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

  class MapReduceCollectionFetcher

    def initialize(store, storage_name, key, value)
      @store, @storage_name, @key, @value = store, storage_name, key, value
    end

    def drafts
      drafts = [ ]
      @store.each do |object_id, draft|
        drafts << draft if draft.properties[@key] == @value
      end
      drafts
    end

  end

  def setup
    @store = { }
  end

  def teardown
    @store = nil
  end

  def fetch(id)
    raise GOM::Storage::Adapter::NoSetupError unless @store
    @store[id]
  end

  def store(draft)
    raise GOM::Storage::Adapter::NoSetupError unless @store
    # store relations
    draft.relations.each do |key, related_object_proxy|
      related_object = related_object_proxy.object
      GOM::Storage.store related_object, configuration.name
      id = GOM::Object::Mapping.id_by_object related_object
      draft.relations[key] = GOM::Object::Proxy.new id
    end

    # may generate an id
    draft.object_id ||= next_id

    # store the draft
    @store[draft.object_id] = draft

    draft.object_id
  end

  def remove(id)
    raise GOM::Storage::Adapter::NoSetupError unless @store
    @store.delete id
  end

  def count
    raise GOM::Storage::Adapter::NoSetupError unless @store
    @store.size
  end

  def collection(view_name)
    raise GOM::Storage::Adapter::NoSetupError unless @store
    case view_name.to_sym
      when :test_object_class_view
        GOM::Object::Collection.new ClassCollectionFetcher.new(@store, configuration.name, "GOM::Spec::Object"), configuration.name
      when :test_map_view
        GOM::Object::Collection.new MapReduceCollectionFetcher.new(@store, configuration.name, :number, 11), configuration.name
    end
  end

  private

  def next_id
    "object_#{@store.size + 1}"
  end

end

GOM::Storage::Adapter.register :fake_adapter, FakeAdapter
