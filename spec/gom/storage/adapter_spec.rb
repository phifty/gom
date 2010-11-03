require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe GOM::Storage::Adapter do

  before :each do
    @configuration = Object.new
    @adapter = GOM::Storage::Adapter.new @configuration
  end

  describe "register" do

    it "should register a given adapter with a given id" do
      GOM::Storage::Adapter.register :test_adapter, @adapter.class
      GOM::Storage::Adapter[:test_adapter].should == @adapter.class
    end

  end

  describe "fetch" do

    it "should raise a NotImplementedError" do
      lambda do
        @adapter.fetch
      end.should raise_error(NotImplementedError)
    end

  end

  describe "store" do

    it "should raise a NotImplementedError" do
      lambda do
        @adapter.store
      end.should raise_error(NotImplementedError)
    end

  end

  describe "remove" do

    it "should raise a NotImplementedError" do
      lambda do
        @adapter.remove
      end.should raise_error(NotImplementedError)
    end

  end

end
