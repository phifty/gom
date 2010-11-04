require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

describe GOM::Object do

  describe "id" do

    before :each do
      @object = Object.new
      @id = "object_1"
      GOM::Object::Mapping.stub!(:id_by_object).and_return(@id)
    end

    it "should call id_by_object of object mapping" do
      GOM::Object::Mapping.should_receive(:id_by_object).with(@object).and_return(@id)
      GOM::Object.id(@object).should == @id
    end

  end

end
