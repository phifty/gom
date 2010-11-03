require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib", "gom"))

GOM::Storage::Configuration.read File.join(File.dirname(__FILE__), "..", "storage.configuration")

class House

  attr_reader :id
  attr_accessor :number

end

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

    it "should return the correct object" do
      GOM::Storage::Configuration[:test_storage].adapter.should_receive(:store).with({
        :class => "House",
        :properties => {
          :number => 11
        }
      }).and_return("house_2")
      id = GOM::Storage.store "test_storage", @house
      id.should == "test_storage:house_2"
      @house.id.should == "test_storage:house_2"
    end

  end

end
