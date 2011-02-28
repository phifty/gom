require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

describe GOM::Object::Draft do

  before :each do
    @draft = described_class.new "object_1", "Object", { "test" => "test value" }, { "test" => "test_storage:object_2" }
  end

  describe "initialize" do

    it "should set the object id" do
      @draft.object_id.should == "object_1"
    end

    it "should set the class name" do
      @draft.class_name.should == "Object"
    end

    it "should set the properties" do
      @draft.properties.should == { "test" => "test value" }
    end

    it "should set the relations" do
      @draft.relations.should == { "test" => "test_storage:object_2" }
    end

  end

  describe "properties" do

    it "should return an empty hash if no properties are given" do
      @draft.properties = nil
      @draft.properties.should == { }
    end

  end

  describe "relations" do

    it "should return an empty hash if no relations are given" do
      @draft.relations = nil
      @draft.relations.should == { }
    end

  end

  describe "==" do

    before :each do
      @same_draft = described_class.new "object_1", "Object", { "test" => "test value" }, { "test" => "test_storage:object_2" }
    end

    it "should return true if all members are the same" do
      @draft.should == @same_draft
    end

  end

end
