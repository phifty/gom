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
    @inspector.stub!(:perform)
    @inspector.stub!(:object_hash).and_return(@object_hash)
    GOM::Object::Inspector.stub!(:new).and_return(@inspector)

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
      pending "will be needed at the next refactoring"
      GOM::Object::Inspector.should_receive(:new).with(@object).and_return(@inspector)
      @remover.perform
    end

    it "should set the object's id to nil" do
      @remover.perform
      @remover.object.id.should be_nil
    end

  end

end
