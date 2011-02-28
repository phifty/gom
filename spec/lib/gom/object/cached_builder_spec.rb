require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

describe GOM::Object::CachedBuilder do

  before :each do
    @object_id = "object_1"
    @draft = mock GOM::Object::Draft, :id => @object_id

    @id = mock GOM::Object::Id
    GOM::Object::Id.stub(:new).and_return(@id)

    @object = mock Object
    GOM::Object::Mapping.stub(:object_by_id).and_return(@object)
    GOM::Object::Mapping.stub(:put)

    @builder = mock GOM::Object::Builder, :object => @object
    GOM::Object::Builder.stub(:new).and_return(@builder)

    @cached_builder = described_class.new @draft, "test_storage"
  end

  describe "object" do

    it "should initialize the right id" do
      GOM::Object::Id.should_receive(:new).with("test_storage", "object_1").and_return(@id)
      @cached_builder.object
    end

    it "should check the mapping for the object" do
      GOM::Object::Mapping.should_receive(:object_by_id).with(@id).and_return(@object)
      @cached_builder.object
    end

    it "should initialize the object builder" do
      GOM::Object::Builder.should_receive(:new).with(@draft, @object).and_return(@builder)
      @cached_builder.object
    end

    it "should set the mapping for the object" do
      GOM::Object::Mapping.should_receive(:put).with(@object, @id).and_return(@object)
      @cached_builder.object
    end

    it "should return the object" do
      object = @cached_builder.object
      object.should == @object
    end

  end

end
