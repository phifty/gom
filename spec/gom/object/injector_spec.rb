require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe GOM::Object::Injector do

  before :each do
    @object = Object.new
    @hash = {
        :class => "Object",
        :id => "object_1",
        :properties => { :test => "test value" }
    }
    @injector = GOM::Object::Injector.new @object, @hash
  end

  describe "perform" do

    it "should set the object id" do
      @injector.perform
      @injector.object.instance_variable_get(:@id).should == "object_1"
    end

    it "should set the object instance variables" do
      @injector.perform
      @injector.object.instance_variable_get(:@test).should == "test value"
    end

  end

  describe "clear_id" do

    it "should set the object's id to nil" do
      @injector.clear_id
      @injector.object.instance_variable_get(:@id).should be_nil
    end

  end

  describe "write_id" do

    it "should set the object's id" do
      @injector.write_id "object_2"
      @injector.object.instance_variable_get(:@id).should == "object_2"
    end

    it "should set the object's id from the object hash if no id is given" do
      @injector.write_id
      @injector.object.instance_variable_get(:@id).should == "object_1"
    end

  end

end
