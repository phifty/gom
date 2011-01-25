require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

describe GOM::Object::Inspector do

  before :each do
    @related_object_proxy = GOM::Object.reference GOM::Spec::Object.new

    @object = GOM::Spec::Object.new
    @object.number = 12
    @object.related_object = @related_object_proxy

    @inspector = GOM::Object::Inspector.new @object
  end

  describe "draft" do

    it "should return the correct draft" do
      draft = @inspector.draft
      draft.should == GOM::Object::Draft.new(nil, GOM::Spec::Object.to_s, { :number => 12 }, { :related_object => @related_object_proxy })
    end

  end

end
