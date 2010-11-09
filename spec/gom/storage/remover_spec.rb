require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe GOM::Storage::Remover do

  before :each do
    @id = GOM::Object::Id.new "test_storage", "object_1"
    @object = Object.new

    @adapter = Object.new
    @adapter.stub!(:remove)
    @configuration = Object.new
    @configuration.stub!(:adapter).and_return(@adapter)
    GOM::Storage::Configuration.stub!(:[]).and_return(@configuration)

    GOM::Object::Mapping.stub!(:id_by_object).with(@object).and_return(@id)
    GOM::Object::Mapping.stub!(:remove_by_object)

    @remover = GOM::Storage::Remover.new @object
  end

  describe "perform" do

    it "should route the call to the correct storage" do
      GOM::Storage::Configuration.should_receive(:[]).with("test_storage")
      @remover.perform
    end

    it "should remove the object with the adapter instance" do
      @adapter.should_receive(:remove).with("object_1")
      @remover.perform
    end

    it "should raise an ArugmentError if no mapping for the given object exists" do
      GOM::Object::Mapping.stub!(:id_by_object).with(@object).and_return(nil)
      lambda do
        @remover.perform
      end.should raise_error(ArgumentError)
    end

    it "should remove the mapping" do
      GOM::Object::Mapping.should_receive(:remove_by_object).with(@object)
      @remover.perform
    end

  end

end
