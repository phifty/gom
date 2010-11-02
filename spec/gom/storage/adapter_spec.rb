require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe GOM::Storage::Adapter do

  describe "register" do

    before :each do
      @adapter_class = GOM::Storage::Adapter
    end

    it "should register a given adapter with a given id" do
      GOM::Storage::Adapter.register :test_adapter, @adapter_class
      GOM::Storage::Adapter[:test_adapter].should == @adapter_class
    end

  end

end
