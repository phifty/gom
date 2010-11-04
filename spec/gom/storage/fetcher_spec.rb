require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe GOM::Storage::Fetcher do

  before :each do
    @object = Object.new
    @object.instance_variable_set :@test, "test value"
    @object_hash = {
      :class => "Object",
      :properties => { :test => "test value" }
    }

    @adapter = Object.new
    @adapter.stub!(:fetch).and_return(@object_hash)
    @configuration = Object.new
    @configuration.stub!(:adapter).and_return(@adapter)
    GOM::Storage::Configuration.stub!(:[]).and_return(@configuration)

    GOM::Object::Mapping.stub!(:object_by_id)
    GOM::Object::Mapping.stub!(:put)

    @injector = Object.new
    @injector.stub!(:perform)
    @injector.stub!(:object).and_return(@object)
    GOM::Object::Injector.stub!(:new).and_return(@injector)

    @fetcher = GOM::Storage::Fetcher.new "test_storage:house_1"
  end

  describe "perform" do

    it "should route the call to the correct storage" do
      GOM::Storage::Configuration.should_receive(:[]).with("test_storage")
      @fetcher.perform
    end

    it "should fetch the id from the adapter instance" do
      @adapter.should_receive(:fetch).with("house_1").and_return(@object_hash)
      @fetcher.perform
    end

    it "should not initialize the object if an instance is given" do
      object = Object.new
      @fetcher.object = object
      GOM::Object::Injector.should_receive(:new).with(object, @object_hash).and_return(@injector)
      @fetcher.perform
    end

    it "should check if a mapping exists for the object" do
      object = Object.new
      GOM::Object::Mapping.should_receive(:object_by_id).with("test_storage:house_1").and_return(object)
      @fetcher.perform
    end

    it "should initialize the object if not given" do
      GOM::Object::Injector.should_receive(:new).with(an_instance_of(Object), @object_hash).and_return(@injector)
      @fetcher.perform
    end

    it "should create mapping between object and id" do
      GOM::Object::Mapping.should_receive(:put).with(@object, "test_storage:house_1")
      @fetcher.perform
    end

    it "should set the object's instance variables" do
      @fetcher.perform
      @fetcher.object.instance_variable_get(:@test).should == "test value"
    end

  end

end
