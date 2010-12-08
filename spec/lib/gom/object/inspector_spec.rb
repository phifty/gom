require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

describe GOM::Object::Inspector do

  before :each do
    @related_object_proxy = GOM::Object.reference Object.new

    @object = Object.new
    @object.instance_variable_set :@test, "test value"
    @object.instance_variable_set :@related_object, @related_object_proxy

    @object_hash = {
      :class => "Object",
      :properties => { :test => "test value" },
      :relations => { :related_object => @related_object_proxy }
    }

    @inspector = GOM::Object::Inspector.new @object
  end

  describe "perform" do

    it "should return the correct object hash" do
      @inspector.perform
      @inspector.object_hash.should == @object_hash
    end

  end

end
