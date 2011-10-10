
class FakeAdapter < GOM::Storage::Adapter

  class AllCollectionFetcher

    def initialize(store, storage_name)
      @store, @storage_name = store, storage_name
    end

    def drafts
      @store.values
    end

  end

  class PropertyCollectionFetcher

    def initialize(store, storage_name, filter, properties)
      @store, @storage_name, @filter, @properties = store, storage_name, filter, properties
    end

    def drafts
      drafts = [ ]
      @store.each do |object_id, draft|
        match = true
        (@filter || { }).each do |property_name, condition|
          condition_kind, condition_value = *condition
          match &&= case condition_kind
            when :equals
              property_name == :model_class ?
                draft.class_name == condition_value :
                draft.properties[property_name] == condition_value
            when :greater_than
              draft.properties[property_name] > condition_value
            else
              raise ArgumentError, "condition kind #{condition_kind} is not implemented"
          end
        end
        drafts << draft if match
      end
      drafts
    end

  end

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
    view = configuration.views[view_name]
    case view_name.to_sym
      when :test_all_view
        GOM::Object::Collection.new AllCollectionFetcher.new(@store, configuration.name), configuration.name
      when :test_property_view
        GOM::Object::Collection.new PropertyCollectionFetcher.new(@store, configuration.name, view.filter, view.properties), configuration.name
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
