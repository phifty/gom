require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

describe GOM::Object::Builder do

  before :each do
    @related_object_proxy = Object.new

    @draft = GOM::Object::Draft.new nil, "Object", { :test => "test value" }, { :related_object => @related_object_proxy }
    @builder = described_class.new @draft
  end

  describe "object" do

    it "should initialize an object of the right class" do
      object = @builder.object
      object.class.should == Object
    end

    it "should not initialize an object if one is given" do
      object = Object.new
      @builder.object = object
      @builder.object.should === object
    end

    it "should set the properties" do
      object = @builder.object
      object.instance_variable_get(:@test).should == "test value"
    end

    it "should set the relations" do
      object = @builder.object
      object.instance_variable_get(:@related_object).should == @related_object_proxy
    end

    it "should work without a properties hash" do
      @draft.properties = nil
      lambda do
        @builder.object
      end.should_not raise_error
    end

    it "should work without a relations hash" do
      @draft.relations = nil
      lambda do
        @builder.object
      end.should_not raise_error
    end

  end

end
