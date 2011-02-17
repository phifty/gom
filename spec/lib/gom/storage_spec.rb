require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe GOM::Storage do

  before :each do
    @id_string = "test_storage:object_1"
    @object = Object.new
  end

  describe "setup" do

    before :each do
      GOM::Object::Mapping.stub(:clear!)
      described_class::Configuration.stub(:setup_all)
    end

    it "should clear the mapping" do
      GOM::Object::Mapping.should_receive(:clear!)
      described_class.setup
    end

    it "should setup all storage configurations" do
      described_class::Configuration.should_receive(:setup_all)
      described_class.setup
    end

  end

  describe "teardown" do

    before :each do
      described_class::Configuration.stub(:teardown_all)
    end

    it "should teardown all storage configurations" do
      described_class::Configuration.should_receive(:teardown_all)
      described_class.teardown
    end

  end

  describe "fetch" do

    before :each do
      @id = mock GOM::Object::Id
      GOM::Object::Id.stub(:new).and_return(@id)

      @fetcher = mock GOM::Storage::Fetcher, :object => @object
      described_class::Fetcher.stub(:new).and_return(@fetcher)
    end

    it "should initialize the id correctly" do
      GOM::Object::Id.should_receive(:new).with(@id_string).and_return(@id)
      described_class.fetch @id_string
    end

    it "should initialize the fetcher correctly" do
      GOM::Storage::Fetcher.should_receive(:new).with(@id).and_return(@fetcher)
      described_class.fetch @id_string
    end

    it "should return the object" do
      described_class.fetch(@id_string).should == @object
    end

    it "should return nil if nil is given" do
      described_class::Fetcher.should_receive(:new).with(nil).and_return(@fetcher)
      @fetcher.stub(:object).and_return(nil)

      described_class.fetch(nil).should be_nil
    end

  end

  describe "store" do

    before :each do
      @storage_name = "another_test_storage"
      @saver = mock described_class::Saver, :perform => nil
      described_class::Saver.stub(:new).and_return(@saver)
    end

    it "should initialize the saver correctly" do
      described_class::Saver.should_receive(:new).with(@object, @storage_name).and_return(@saver)
      described_class.store @object, @storage_name
    end

    it "should perform a store" do
      @saver.should_receive(:perform)
      described_class.store @object
    end

  end

  describe "remove" do

    before :each do
      @id = mock GOM::Object::Id
      GOM::Object::Id.stub(:new).and_return(@id)

      @remover = mock described_class::Remover, :perform => nil
      described_class::Remover.stub(:new).and_return(@remover)
    end

    it "should initialize the remover correctly" do
      described_class::Remover.should_receive(:new).with(@object).and_return(@remover)
      described_class.remove @object
    end

    it "should perform a remove" do
      @remover.should_receive(:perform)
      described_class.remove @object
    end

    it "should convert a given string into an id" do
      GOM::Object::Id.should_receive(:new).with("test_storage:object_1").and_return(@id)
      described_class::Remover.should_receive(:new).with(@id).and_return(@remover)
      described_class.remove "test_storage:object_1"
    end

  end

  describe "collection" do

    before :each do
      @collection = mock GOM::Object::Collection
      @adapter = mock GOM::Storage::Adapter, :collection => @collection
      @configuration = mock GOM::Storage::Configuration, :adapter => @adapter
      GOM::Storage::Configuration.stub(:[]).with(:test_storage).and_return(@configuration)
    end

    it "should select the right configuration" do
      GOM::Storage::Configuration.should_receive(:[]).with(:test_storage).and_return(@configuration)
      described_class.collection :test_storage, :argument_one, :argument_two
    end

    it "should pass all arguments to the adapters collection method" do
      @adapter.should_receive(:collection).with(:argument_one, :argument_two)
      described_class.collection :test_storage, :argument_one, :argument_two
    end

    it "should return the adapter's collection" do
      collection = described_class.collection :test_storage
      collection.should == @collection
    end

  end

end
