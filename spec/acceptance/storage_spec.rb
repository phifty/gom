require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib", "gom"))

GOM::Storage::Configuration.read File.join(File.dirname(__FILE__), "..", "storage.configuration")

describe "storage" do

  describe "fetching an object" do

    it "should return the correct object" do
      object = GOM::Storage.fetch "test_storage:object_1"
      object.should be_instance_of(Object)
      object.instance_variable_get(:@number).should == 5
      GOM::Object.id(object).should == "test_storage:object_1"
    end

  end

  describe "storing an object" do

    before :each do
      @object = Object.new
      @object.instance_variable_set :@number, 11
    end

    it "should store the object" do
      GOM::Storage::Configuration[:test_storage].adapter.should_receive(:store).with({
        :class => "Object",
        :properties => {
          :number => 11
        }
      }).and_return("object_1")
      GOM::Storage.store @object, "test_storage"
    end

    it "should use default storage if nothing specified" do
      GOM::Storage::Configuration[:test_storage].adapter.should_receive(:store).with({
        :class => "Object",
        :properties => {
          :number => 11
        }
      }).and_return("object_1")
      GOM::Storage.store @object
    end

    it "should set the object's id" do
      GOM::Storage.store @object, "test_storage"
      GOM::Object.id(@object).should == "test_storage:object_1"
    end

  end

  describe "removing an object" do

    before :each do
      @object = GOM::Storage.fetch "test_storage:object_1"
    end

    it "should remove the object" do
      GOM::Storage::Configuration[:test_storage].adapter.should_receive(:remove).with("object_1")
      GOM::Storage.remove @object
    end

    it "should remove the object identified by the id" do
      GOM::Storage::Configuration[:test_storage].adapter.should_receive(:remove).with("object_1")
      GOM::Storage.remove "test_storage:object_1"
    end

    it "should remove the object's id" do
      GOM::Storage.remove @object
      GOM::Object.id(@object).should be_nil
    end

  end

end
