require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe GOM::Object::Id do

  before :each do
    @id = GOM::Object::Id.new "test_storage", "object_1"
  end

  describe "initialize" do

    it "should initialize a blank id" do
      id = GOM::Object::Id.new
      id.storage_name.should == nil
      id.object_id.should == nil
    end

    it "should initialize with an id string" do
      id = GOM::Object::Id.new "test_storage:object_1"
      id.storage_name.should == "test_storage"
      id.object_id.should == "object_1"
    end

    it "should initialize with seperated parameters" do
      id = GOM::Object::Id.new "test_storage", "object_1"
      id.storage_name.should == "test_storage"
      id.object_id.should == "object_1"
    end

  end

  describe "==" do

    before :each do
      @id_one = GOM::Object::Id.new "test_storage", "object_1"
      @id_two = GOM::Object::Id.new "test_storage", "object_2"
    end

    it "should be true when compared to an id with the same parameters" do
      (@id == @id_one).should be_true
    end

    it "should be false when compared to a different id" do
      (@id == @id_two).should be_false
    end

  end

  describe "to_s" do

    it "should return the combined parameters" do
      @id.to_s.should == "test_storage:object_1"
    end

  end

end
