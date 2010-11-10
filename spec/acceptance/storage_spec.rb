require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "lib", "gom"))

GOM::Storage::Configuration.read File.join(File.dirname(__FILE__), "..", "storage.configuration")

describe "storage" do

  before :each do
    @fake_adapter = GOM::Storage::Configuration[:test_storage].adapter
  end

  describe "fetching an object" do

    before :each do
      @object = Object.new
      @object.instance_variable_set :@number, 5
      GOM::Storage.store @object, :test_storage
      @id = GOM::Object.id(@object)
    end

    after :each do
      GOM::Storage.remove @object
    end

    it "should return the correct object" do
      object = GOM::Storage.fetch @id
      object.should be_instance_of(Object)
      object.instance_variable_get(:@number).should == 5
      GOM::Object.id(object).should == @id
    end

  end

  describe "storing an object" do

    before :each do
      @object = Object.new
      @object.instance_variable_set :@number, 11
    end

    it "should store the object" do
      GOM::Storage.store @object, :test_storage
      object = GOM::Storage.fetch GOM::Object.id(@object)
      object.should == @object
    end

    it "should use default storage if nothing specified" do
      GOM::Storage.store @object
      GOM::Object.id(@object).should =~ /^test_storage:/
    end

    it "should set the object's id" do
      GOM::Storage.store @object, "test_storage"
      GOM::Object.id(@object).should =~ /^test_storage:object_\d$/
    end

  end

  describe "removing an object" do

    before :each do
      @object = Object.new
      @object.instance_variable_set :@number, 5
      GOM::Storage.store @object, :test_storage
      @id = GOM::Object.id(@object)
    end

    it "should remove the object" do
      GOM::Storage.remove @object
      GOM::Storage.fetch(@id).should be_nil
    end

    it "should remove the object identified by the id" do
      GOM::Storage.remove @id
      GOM::Storage.fetch(@id).should be_nil
    end

    it "should remove the object's id" do
      GOM::Storage.remove @object
      GOM::Object.id(@object).should be_nil
    end

  end

end
