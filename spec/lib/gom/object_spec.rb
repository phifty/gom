require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe GOM::Object do

  describe "id" do

    before :each do
      @id_string = "test_storage:object_1"
      @id = GOM::Object::Id.new @id_string
      @object = Object.new
      GOM::Object::Mapping.stub!(:id_by_object).and_return(@id)
    end

    it "should call id_by_object of object mapping" do
      GOM::Object::Mapping.should_receive(:id_by_object).with(@object).and_return(@id)
      GOM::Object.id(@object).should == @id_string
    end

    it "should return nil if the call of id_by_object returned nil" do
      GOM::Object::Mapping.stub!(:id_by_object).and_return(nil)
      GOM::Object.id(@object).should be_nil
    end

  end

  describe "reference" do

    before :each do
      @object = Object.new
    end

    it "should return a proxy for the given object" do
      proxy = GOM::Object.reference @object
      proxy.should be_instance_of(GOM::Object::Proxy)
      proxy.object.should == @object
    end

  end

end
