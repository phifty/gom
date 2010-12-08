require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

describe GOM::Storage::Configuration do

  before :each do
    @adapter = mock GOM::Storage::Adapter, :setup => nil
    @adapter_class = mock Class, :new => @adapter
    GOM::Storage::Adapter.stub(:[]).and_return(@adapter_class)

    described_class.read File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "storage.configuration"))
    @configuration = described_class[:test_storage]
  end

  describe "setup" do

    it "should call setup on the adapter instance" do
      @adapter.should_receive(:setup)
      @configuration.setup
    end

  end

  describe "name" do

    it "should return the configuration's name" do
      @configuration.name.should == "test_storage"
    end

  end

  describe "[]" do

    it "should return the configuration value" do
      @configuration[:test].should == "test value"
    end

  end

  describe "values_at" do

    it "should return multiple configuration values" do
      @configuration.values_at(:adapter, :test).should == [ "fake_adapter", "test value" ]
    end

  end

  describe "read" do

    it "should read the configuration file" do
      @configuration.should be_instance_of(described_class)
    end

    it "should initialize the right adapter class" do
      @configuration.adapter_class.should == @adapter_class
    end

    it "should create an adapter instance if requested" do
      @adapter_class.should_receive(:new).with(@configuration).and_return(@adapter)
      @configuration.adapter.should == @adapter
    end

  end

  describe "setup_all" do

    before :each do
      @configuration.stub(:setup)
    end

    it "should call setup on each configuration" do
      @configuration.should_receive(:setup)
      described_class.setup_all
    end

  end

  describe "default" do

    it "should select the first configuration" do
      described_class.default.should == GOM::Storage::Configuration[:test_storage]
    end

    it "should raise StandardError if no configuration loaded" do
      described_class.instance_variable_set :@configurations, { }
      lambda do
        described_class.default
      end.should raise_error(StandardError)
    end

  end

end