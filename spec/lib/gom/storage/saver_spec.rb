require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

describe GOM::Storage::Saver do

  before :each do
    @id = GOM::Object::Id.new "test_storage", "object_1"

    @object = Object.new
    @object.instance_variable_set :@test, "test value"
    @object.freeze

    @draft = GOM::Object::Draft.new "object_1", "Object", { :test => "test value" }

    GOM::Object::Mapping.stub(:id_by_object).with(@object).and_return(@id)
    GOM::Object::Mapping.stub(:put)

    @adapter = mock GOM::Storage::Adapter, :store => "object_1"
    @configuration = mock GOM::Storage::Configuration, :name => "default_test_storage", :adapter => @adapter
    GOM::Storage::Configuration.stub(:[]).and_return(@configuration)
    GOM::Storage::Configuration.stub(:default).and_return(@configuration)

    @inspector = mock GOM::Object::Inspector, :draft => @draft
    GOM::Object::Inspector.stub(:new).and_return(@inspector)

    @saver = GOM::Storage::Saver.new @object
  end

  describe "perform" do

    it "should check the mapping if an id is existing" do
      GOM::Object::Mapping.should_receive(:id_by_object).with(@object).and_return(@id)
      @saver.perform
    end

    it "should override the storage name if given" do
      @saver.instance_variable_set :@storage_name, "another_test_storage"
      @saver.perform
      @saver.storage_name.should == "another_test_storage"
    end

    it "should select the default storage if no storage name can be detected" do
      GOM::Object::Mapping.stub(:id_by_object).with(@object).and_return(nil)
      @saver.perform
      @saver.storage_name.should == "default_test_storage"
    end

    it "should select the correct storage" do
      GOM::Storage::Configuration.should_receive(:[]).with("test_storage").and_return(@configuration)
      @saver.perform
    end

    it "should store the object with the adapter instance" do
      @adapter.should_receive(:store).with(@draft).and_return("object_1")
      @saver.perform
    end

    it "should store the object without an id if no mapping exists" do
      GOM::Object::Mapping.stub(:id_by_object).with(@object).and_return(nil)
      @draft.object_id = nil

      @adapter.should_receive(:store).with(@draft).and_return("object_1")
      @saver.perform
    end

    it "should create a mapping between object and id" do
      GOM::Object::Mapping.should_receive(:put).with(@object, @id)
      @saver.perform
    end

  end

end
