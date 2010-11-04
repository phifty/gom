require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib", "gom"))
require File.join(File.dirname(__FILE__), "model")

GOM::Storage::Configuration.read File.join(File.dirname(__FILE__), "..", "storage.configuration")

describe "object" do

  describe "getting it's id" do

    before :each do
      @house = House.new
      @house.number = 15
      GOM::Storage.store "test_storage", @house
    end

    it "should return the id" do
      id = GOM::Object.id @house
      id.should == "test_storage:house_1"
    end

  end

end
