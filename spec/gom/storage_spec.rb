require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

class Test
  attr_reader :id
  attr_reader :test
end

describe GOM::Storage do

  describe "fetch" do

    before :each do
      @hash = {
        :class => "Test",
        :properties => { :test => "test value" }
      }
      @adapter = Object.new
      @adapter.stub!(:fetch).and_return(@hash)
      @configuration = Object.new
      @configuration.stub!(:adapter).and_return(@adapter)
      GOM::Storage::Configuration.stub!(:[]).and_return(@configuration)
    end

    def do_fetch(object = nil)
      GOM::Storage.fetch "test_storage:house_1", object
    end

    it "should route the call to the correct storage" do
      GOM::Storage::Configuration.should_receive(:[]).with("test_storage")
      do_fetch
    end

    it "should fetch the id from the adapter instance" do
      @adapter.should_receive(:fetch).with("house_1").and_return(@hash)
      do_fetch
    end

    it "should not initialize the object if an instance is given" do
      do_fetch(Object.new).should be_instance_of(Object)
    end

    it "should initialize the object" do
      do_fetch.should be_instance_of(Test)
    end

    it "should set the object's id" do
      do_fetch.id.should == "test_storage:house_1"
    end

    it "should set the object's instance variables" do
      do_fetch.test.should == "test value"
    end

  end

end
