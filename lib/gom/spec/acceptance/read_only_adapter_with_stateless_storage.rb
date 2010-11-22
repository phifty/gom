
shared_examples_for "a read-only adapter connected to a stateless storage" do

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

    it "should raise a NoWritePermissionError" do
      lambda do
        GOM::Storage.store Object.new, "test_storage"
      end.should raise_error(GOM::Storage::NoWritePermissionError)
    end

  end

  describe "removing an object" do

    before :each do
      @object = GOM::Storage.fetch "test_storage:object_1"
    end

    it "should raise a NoWritePermissionError" do
      lambda do
        GOM::Storage.remove @object
      end.should raise_error(GOM::Storage::NoWritePermissionError)
    end

  end

end
