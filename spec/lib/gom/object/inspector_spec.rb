require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

describe GOM::Object::Inspector do

  before :each do
    @related_object_proxy = GOM::Object.reference Object.new

    @object = Object.new
    @object.instance_variable_set :@test, "test value"
    @object.instance_variable_set :@related_object, @related_object_proxy

    @inspector = GOM::Object::Inspector.new @object
  end

  describe "draft" do

    before :each do
      @draft = GOM::Object::Draft.new nil, "Object", { :test => "test value" }, { :related_object => @related_object_proxy }
    end

    it "should return the correct draft" do
      draft = @inspector.draft
      draft.should == @draft
    end

  end

end
