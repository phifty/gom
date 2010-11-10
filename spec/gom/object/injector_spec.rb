require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe GOM::Object::Injector do

  before :each do
    @related_object_proxy = Object.new

    @object = Object.new
    @object.instance_variable_set :@old, "old value"
    @object_hash = {
      :class => "Object",
      :properties => { :test => "test value" },
      :relations => { :related_object => @related_object_proxy }
    }
    @injector = GOM::Object::Injector.new @object, @object_hash
  end

  describe "perform" do

    it "should clear all instance variables" do
      @injector.perform
      @injector.object.instance_variables.should_not include(:@old)
    end

    it "should set the properties" do
      @injector.perform
      @injector.object.instance_variable_get(:@test).should == "test value"
    end

    it "should set the relations" do
      @injector.perform
      @injector.object.instance_variable_get(:@related_object).should == @related_object_proxy
    end

  end

end
