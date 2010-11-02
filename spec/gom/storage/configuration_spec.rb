require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe GOM::Storage::Configuration do

  describe "read" do

    before :each do
      GOM::Storage::Configuration.read File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "storage.configuration"))
      @configuration = GOM::Storage::Configuration[:test_storage]
    end

    it "should read the configuration file" do
      @configuration.should be_instance_of(GOM::Storage::Configuration)
    end

    it "should initialize the right adapter class" do
      @configuration.adapter_class.should == FakeAdapter
    end

    it "should create an adapter instance if requested" do
      adapter = Object.new
      FakeAdapter.should_receive(:new).with(@configuration).and_return(adapter)
      @configuration.adapter.should == adapter
    end

  end

end
