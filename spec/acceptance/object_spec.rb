require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib", "gom"))

GOM::Storage::Configuration.read File.join(File.dirname(__FILE__), "..", "storage.configuration")

describe "object" do

  before :each do
    GOM::Storage.setup
    @object = Object.new
  end

  after :each do
    GOM::Storage.teardown
  end

  describe "getting it's id" do

    before :each do
      GOM::Storage.store @object, "test_storage"
    end

    it "should return the id" do
      id = GOM::Object.id @object
      id.should == "test_storage:object_1"
    end

  end

  describe "getting an object reference" do

    it "should create an object proxy" do
      GOM::Object.reference(@object).should be_instance_of(GOM::Object::Proxy)
    end

  end

end
