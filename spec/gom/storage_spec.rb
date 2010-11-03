require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

class Test
  attr_reader :id
  attr_reader :test
end

describe GOM::Storage do

  describe "fetch" do

    before :each do
      @object = Object.new
      @fetcher = Object.new
      @fetcher.stub!(:perform)
      @fetcher.stub!(:object).and_return(@object)
      GOM::Storage::Fetcher.stub!(:new).and_return(@fetcher)
    end

    it "should perform a fetch" do
      @fetcher.should_receive(:perform)
      GOM::Storage.fetch "test_storage:house_1"
    end

    it "should return the object" do
      GOM::Storage.fetch("test_storage:house_1").should == @object
    end

  end

  describe "store" do

    before :each do
      @object = Object.new
      @saver = Object.new
      @saver.stub!(:perform)
      @saver.stub!(:id).and_return("test_storage:house_2")
      GOM::Storage::Saver.stub!(:new).and_return(@saver)
    end

    it "should perform a store" do
      @saver.should_receive(:perform)
      GOM::Storage.store "test_storage", @object
    end

    it "should return the id" do
      GOM::Storage.store("test_storage", @object).should == "test_storage:house_2"
    end

  end

end
