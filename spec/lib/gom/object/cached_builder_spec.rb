require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

describe GOM::Object::CachedBuilder do

  before :each do
    @object_hash = mock Hash
    @id = mock GOM::Object::Id

    @object = mock Object
    GOM::Object::Mapping.stub(:object_by_id).and_return(@object)
    GOM::Object::Mapping.stub(:put)

    @builder = mock GOM::Object::Builder, :object => @object
    GOM::Object::Builder.stub(:new).and_return(@builder)

    @cached_builder = described_class.new @object_hash, @id
  end

  describe "object" do

    it "should check the mapping for the object" do
      GOM::Object::Mapping.should_receive(:object_by_id).with(@id).and_return(@object)
      @cached_builder.object
    end

    it "should initialize the object builder" do
      GOM::Object::Builder.should_receive(:new).with(@object_hash, @object).and_return(@builder)
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
