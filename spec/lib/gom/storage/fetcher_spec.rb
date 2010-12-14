require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

describe GOM::Storage::Fetcher do

  before :each do
    @id = GOM::Object::Id.new "test_storage", "object_1"
    @object = Object.new
    @object.instance_variable_set :@test, "test value"
    @object_hash = {
      :class => "Object",
      :properties => { :test => "test value" }
    }

    @adapter = mock GOM::Storage::Adapter, :fetch => @object_hash
    @configuration = mock GOM::Storage::Configuration, :adapter => @adapter
    GOM::Storage::Configuration.stub(:[]).and_return(@configuration)

    @builder = mock GOM::Object::CachedBuilder, :object => @object
    GOM::Object::CachedBuilder.stub(:new).and_return(@builder)

    @fetcher = described_class.new @id
    @fetcher.stub(:object_class).and_return(@klass)
  end

  describe "object" do

    it "should do no fetch if no id is given" do
      @fetcher.id = nil
      @adapter.should_not_receive(:fetch)
      @fetcher.object
    end

    it "should route the call to the correct storage" do
      GOM::Storage::Configuration.should_receive(:[]).with("test_storage")
      @fetcher.object
    end

    it "should fetch the id from the adapter instance" do
      @adapter.should_receive(:fetch).with("object_1").and_return(@object_hash)
      @fetcher.object
    end

    it "should initialize the cached object builder" do
      GOM::Object::CachedBuilder.should_receive(:new).with(@object_hash, @id).and_return(@builder)
      @fetcher.object
    end

    it "should set the object's instance variables" do
      object = @fetcher.object
      object.instance_variable_get(:@test).should == "test value"
    end

    it "should return nil if storage adapter returned nil" do
      @adapter.stub(:fetch).and_return(nil)
      object = @fetcher.object
      object.should be_nil
    end

  end

end
