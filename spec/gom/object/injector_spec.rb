require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe GOM::Object::Injector do

  before :each do
    @object = Object.new
    @object_hash = {
      :class => "Object",
      :properties => { :test => "test value" }
    }
    @injector = GOM::Object::Injector.new @object, @object_hash
  end

  describe "perform" do

    it "should set the object instance variables" do
      @injector.perform
      @injector.object.instance_variable_get(:@test).should == "test value"
    end

  end

end
