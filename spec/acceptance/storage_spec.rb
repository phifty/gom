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

end
