require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

class Test

  attr_accessor :id
  attr_accessor :test

end

describe GOM::Storage::Fetcher do

  before :each do
    @object = Test.new
    @object.id = "test_storage:house_1"
    @object.test = "test value"
    @object_hash = {
      :class => "Test",
      :properties => { :test => "test value" }
    }

    @adapter = Object.new
    @adapter.stub!(:fetch).and_return(@object_hash)
    @configuration = Object.new
    @configuration.stub!(:adapter).and_return(@adapter)
    GOM::Storage::Configuration.stub!(:[]).and_return(@configuration)

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
      @fetcher.object = Object.new
      GOM::Object::Injector.should_receive(:new).with(@fetcher.object, @object_hash).and_return(@injector)
      @fetcher.perform
    end

    it "should initialize the object if not given" do
      GOM::Object::Injector.should_receive(:new).with(an_instance_of(Test), @object_hash).and_return(@injector)
      @fetcher.perform
    end

    it "should set the object's id" do
      @fetcher.perform
      @fetcher.object.id.should == "test_storage:house_1"
    end

    it "should set the object's instance variables" do
      @fetcher.perform
      @fetcher.object.test.should == "test value"
    end

  end

end
