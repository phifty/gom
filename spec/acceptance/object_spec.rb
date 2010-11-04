require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib", "gom"))

GOM::Storage::Configuration.read File.join(File.dirname(__FILE__), "..", "storage.configuration")

describe "object" do

  describe "getting it's id" do

    before :each do
      @object = Object.new
      GOM::Storage.store @object, "test_storage"
    end

    it "should return the id" do
      id = GOM::Object.id @object
      id.should == "test_storage:object_1"
    end

  end

end
