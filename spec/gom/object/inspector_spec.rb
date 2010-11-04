require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe GOM::Object::Inspector do

  before :each do
    @object = Object.new
    @object.instance_variable_set :@test, "test value"
    @object_hash = {
      :class => "Object",
      :properties => { :test => "test value" }
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
