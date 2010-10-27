require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

class TestAdapter < GOM::Storage::Adapter

  OBJECTS = {
    "house_1" => {
      "number" => 5
    }
  }.freeze

  def fetch_object(id)
    OBJECTS[id]
  end

end

GOM::Storage.register_adapter :test, TestAdapter

GOM::Storage.read_configuration File.join(File.dirname(__FILE__), "storage.configuration")

class House

  attr_reader :id
  attr_accessor :number

end

describe "storage" do

  describe "fetching an object" do

    it "should return the correct object" do
      house = GOM::Storage.fetch "house_1"
      house.should_not be_nil
      house.id.should == "house_1"
      house.number.should == 5
    end

  end

end
