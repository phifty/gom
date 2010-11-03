require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

class Test

  attr_reader :id
  attr_writer :test

end

describe GOM::Storage::Saver do

  before :each do
    @object = Test.new
    @object.test = "test value"
    @object_hash = {
      :class => "House",
      :properties => {
        :test => "test value"
      }
    }

    @adapter = Object.new
    @adapter.stub!(:store).and_return("house_2")
    @configuration = Object.new
    @configuration.stub!(:adapter).and_return(@adapter)
    GOM::Storage::Configuration.stub!(:[]).and_return(@configuration)

    @inspector = Object.new
    @inspector.stub!(:perform)
    @inspector.stub!(:object_hash).and_return(@object_hash)
    GOM::Object::Inspector.stub!(:new).and_return(@inspector)

    @saver = GOM::Storage::Saver.new "test_storage", @object
  end

  describe "perform" do

    it "should route the call to the correct storage" do
      GOM::Storage::Configuration.should_receive(:[]).with("test_storage")
      @saver.perform
    end

    it "should store the object with the adapter instance" do
      @adapter.should_receive(:store).with(@object_hash).and_return("house_2")
      @saver.perform
    end

    it "should inspect the object" do
      GOM::Object::Inspector.should_receive(:new).with(@object).and_return(@inspector)
      @saver.perform
    end

    it "should set the object's id" do
      @saver.perform
      @saver.object.id.should == "test_storage:house_2"
    end

    it "should return the object's id" do
      @saver.perform
      @saver.id.should == "test_storage:house_2"
    end

  end

end
