require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib", "gom"))
require File.join(File.dirname(__FILE__), "model")

GOM::Storage::Configuration.read File.join(File.dirname(__FILE__), "..", "storage.configuration")

describe "storage" do

  describe "fetching an object" do

    it "should return the correct object" do
      house = GOM::Storage.fetch "test_storage:house_1"
      house.should be_instance_of(House)
      house.id.should == "test_storage:house_1"
      house.number.should == 5
    end

  end

  describe "storing an object" do

    before :each do
      @house = House.new
      @house.number = 11
    end

    it "should store the object" do
      GOM::Storage::Configuration[:test_storage].adapter.should_receive(:store).with({
        :class => "House",
        :properties => {
          :number => 11
        }
      }).and_return("house_2")
      GOM::Storage.store "test_storage", @house
    end

    it "should return the right id" do
      id = GOM::Storage.store "test_storage", @house
      id.should == "test_storage:house_2"
    end

    it "should set the object's id" do
      GOM::Storage.store "test_storage", @house
      @house.id.should == "test_storage:house_2"
    end

  end

  describe "removing an object" do

    before :each do
      @house = House.new
      @house.id = "test_storage:house_3"
      @house.number = 11
    end

    it "should remove the object" do
      GOM::Storage::Configuration[:test_storage].adapter.should_receive(:remove).with("house_3")
      GOM::Storage.remove @house
    end

    it "should remove the object identified by the id" do
      GOM::Storage::Configuration[:test_storage].adapter.should_receive(:remove).with("house_3")
      GOM::Storage.remove "test_storage:house_3"
    end

    it "should remove the object's id" do
      GOM::Storage.remove @house
      @house.id.should be_nil
    end

  end

end
