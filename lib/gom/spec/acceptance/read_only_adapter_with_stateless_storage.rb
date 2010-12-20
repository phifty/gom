
shared_examples_for "a read-only adapter connected to a stateless storage" do

  before :all do
    GOM::Storage.setup
  end

  describe "fetching an object" do

    it "should return the correct object" do
      object = GOM::Storage.fetch "test_storage:object_1"
      object.should be_instance_of(Object)
      object.instance_variable_get(:@number).should == 5
      GOM::Object.id(object).should == "test_storage:object_1"
    end

    it "should return proxy objects that fetches the related objects" do
      object = GOM::Storage.fetch "test_storage:object_1"
      related_object = object.instance_variable_get :@related_object
      related_object.should be_instance_of(GOM::Object::Proxy)
      related_object.object.instance_variable_get(:@test).should == "test value"
    end

  end

  describe "storing an object" do

    it "should raise a ReadOnlyError" do
      lambda do
        GOM::Storage.store Object.new, "test_storage"
      end.should raise_error(GOM::Storage::ReadOnlyError)
    end

  end

  describe "removing an object" do

    before :each do
      @object = GOM::Storage.fetch "test_storage:object_1"
    end

    it "should raise a ReadOnlyError" do
      lambda do
        GOM::Storage.remove @object
      end.should raise_error(GOM::Storage::ReadOnlyError)
    end

  end

  describe "fetching a class collection" do

    it "should return a collection" do
      collection = GOM::Storage.collection :test_storage, :test_object_class_view
      collection.should be_instance_of(GOM::Object::Collection)
    end

    it "should return a collection that contains all object of class Object" do
      collection = GOM::Storage.collection :test_storage, :test_object_class_view
      collection.size > 0
      collection.each do |object_proxy|
        (
          object_proxy.object.instance_variable_get(:@number) == 5 ||
          object_proxy.object.instance_variable_get(:@test) == "test value"
        ).should be_true
      end
    end

  end

end
