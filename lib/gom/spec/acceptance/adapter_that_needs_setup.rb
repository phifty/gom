
shared_examples_for "an adapter that needs setup" do

  before :each do
    GOM::Storage.teardown
  end

  describe "fetching an object" do

    it "should raise a #{GOM::Storage::Adapter::NoSetupError}" do
      lambda do
        GOM::Storage.fetch "test_storage:object_1"
      end.should raise_error(GOM::Storage::Adapter::NoSetupError)
    end

  end

  describe "storing an object" do

    it "should raise a #{GOM::Storage::Adapter::NoSetupError}" do
      lambda do
        GOM::Storage.store :object
      end.should raise_error(GOM::Storage::Adapter::NoSetupError)
    end

  end

  describe "removing an object" do

    it "should raise a #{GOM::Storage::Adapter::NoSetupError}" do
      lambda do
        GOM::Storage.remove "test_storage:object_1"
      end.should raise_error(GOM::Storage::Adapter::NoSetupError)
    end

  end

  describe "counting the objects" do

    it "should raise a #{GOM::Storage::Adapter::NoSetupError}" do
      lambda do
        GOM::Storage.count :test_storage
      end.should raise_error(GOM::Storage::Adapter::NoSetupError)
    end

  end

  describe "fetching a class collection" do

    it "should raise a #{GOM::Storage::Adapter::NoSetupError}" do
      lambda do
        GOM::Storage.collection :test_storage, :test_object_class_view
      end.should raise_error(GOM::Storage::Adapter::NoSetupError)
    end

  end

  describe "fetching a map collection" do

    it "should raise a #{GOM::Storage::Adapter::NoSetupError}" do
      lambda do
        GOM::Storage.collection :test_storage, :test_map_view
      end.should raise_error(GOM::Storage::Adapter::NoSetupError)
    end

  end

end
