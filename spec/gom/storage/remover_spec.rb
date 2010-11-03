require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

class Test

  attr_accessor :id

end

describe GOM::Storage::Remover do

  before :each do
    @object = Test.new
    @object.id = "test_storage:house_3"

    @adapter = Object.new
    @adapter.stub!(:remove)
    @configuration = Object.new
    @configuration.stub!(:adapter).and_return(@adapter)
    GOM::Storage::Configuration.stub!(:[]).and_return(@configuration)

    @inspector = Object.new
    @inspector.stub!(:read_id).and_return("test_storage:house_3")
    GOM::Object::Inspector.stub!(:new).and_return(@inspector)

    @injector = Object.new
    @injector.stub!(:clear_id)
    GOM::Object::Injector.stub!(:new).and_return(@injector)

    @remover = GOM::Storage::Remover.new @object
  end

  describe "perform" do

    it "should route the call to the correct storage" do
      GOM::Storage::Configuration.should_receive(:[]).with("test_storage")
      @remover.perform
    end

    it "should remove the object with the adapter instance" do
      @adapter.should_receive(:remove).with("house_3")
      @remover.perform
    end

    it "should inspect the object" do
      @inspector.should_receive(:read_id).and_return("test_storage:house_3")
      @remover.perform
    end

    it "should set the object's id to nil" do
      @injector.should_receive(:clear_id)
      @remover.perform
    end

  end

end
