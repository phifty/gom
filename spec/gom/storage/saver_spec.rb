require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe GOM::Storage::Saver do

  before :each do
    @object = Object.new
    @object.instance_variable_set :@test, "test value"
    @object.freeze
    @object_hash = {
      :class => "Object",
      :properties => {
        :test => "test value"
      }
    }.freeze

    GOM::Object::Mapping.stub!(:id_by_object)
    GOM::Object::Mapping.stub!(:put)

    @adapter = Object.new
    @adapter.stub!(:store).and_return("object_1")
    @configuration = Object.new
    @configuration.stub!(:adapter).and_return(@adapter)
    GOM::Storage::Configuration.stub!(:[]).and_return(@configuration)
    GOM::Storage::Configuration.stub!(:default).and_return(@configuration)

    @inspector = Object.new
    @inspector.stub!(:perform)
    @inspector.stub!(:object_hash).and_return(@object_hash.dup)
    GOM::Object::Inspector.stub!(:new).and_return(@inspector)

    @saver = GOM::Storage::Saver.new @object, "test_storage"
  end

  describe "perform" do

    it "should check the mapping if an id is existing" do
      GOM::Object::Mapping.should_receive(:id_by_object).with(@object).and_return("test_storage:object_1")
      @adapter.should_receive(:store).with(@object_hash.merge(:id => "object_1"))
      @saver.perform
    end

    it "should set the storage name if not given" do
      @saver.instance_variable_set :@storage_name, nil
      GOM::Object::Mapping.stub!(:id_by_object).with(@object).and_return("another_test_storage:object_1")
      @saver.perform
      @saver.storage_name.should == "another_test_storage"
    end

    it "should select the default storage if no storage name is given" do
      @saver.instance_variable_set :@storage_name, nil
      GOM::Storage::Configuration.should_receive(:default).and_return(@configuration)
      @saver.perform
    end

    it "should select the correct storage" do
      GOM::Storage::Configuration.should_receive(:[]).with("test_storage").and_return(@configuration)
      @saver.perform
    end

    it "should store the object with the adapter instance" do
      @adapter.should_receive(:store).with(@object_hash).and_return("object_1")
      @saver.perform
    end

    it "should store the object under an id if a mapping exists" do
      GOM::Object::Mapping.stub!(:id_by_object).with(@object).and_return("test_storage:object_1")
      @adapter.should_receive(:store).with(@object_hash.merge(:id => "object_1")).and_return("object_1")
      @saver.perform
    end

    it "should inspect the object" do
      @inspector.should_receive(:perform)
      @saver.perform
    end

    it "should create a mapping between object and id" do
      GOM::Object::Mapping.should_receive(:put).with(@object, "test_storage:object_1")
      @saver.perform
    end

  end

end
