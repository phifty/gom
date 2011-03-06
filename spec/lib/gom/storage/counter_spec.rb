require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

describe GOM::Storage::Counter do

  before :each do
    @adapter = mock GOM::Storage::Adapter, :count => 1
    @configuration = mock GOM::Storage::Configuration, :adapter => @adapter
    GOM::Storage::Configuration.stub(:[]).and_return(@configuration)

    @counter = described_class.new "test_storage"
  end

  describe "perform" do

    it "should route the call to the correct storage" do
      GOM::Storage::Configuration.should_receive(:[]).with("test_storage").and_return(@configuration)
      @counter.perform
    end

    it "should fetch the count from the adapter instance" do
      @adapter.should_receive(:count).and_return(1)
      @counter.perform
    end

    it "should return the count" do
      count = @counter.perform
      count.should == 1
    end

  end

end
