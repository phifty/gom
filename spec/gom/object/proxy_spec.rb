require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe GOM::Object::Proxy do

  describe "initialized with an object" do

    before :each do
      @object = Object.new
      @object.stub!(:test_method)

      @proxy = GOM::Object::Proxy.new @object
    end

    it "should pass every call to the object" do
      @object.should_receive(:test_method).with(:test_argument).and_return(:test_result)
      @proxy.test_method(:test_argument).should == :test_result
    end

    describe "object" do

      it "should return the original object" do
        @proxy.object.should == @object
      end

    end

  end

  describe "initialized with an id" do

    before :each do
      @id = GOM::Object::Id.new "test_storage", "object_1"
      @object = Object.new
      @object.stub!(:test_method)

      @fetcher = Object.new
      @fetcher.stub!(:perform)
      @fetcher.stub!(:object).and_return(@object)
      GOM::Storage::Fetcher.stub!(:new).and_return(@fetcher)

      @proxy = GOM::Object::Proxy.new @id
    end

    it "should fetch the object before the call is passed to it" do
      GOM::Storage::Fetcher.should_receive(:new).with(@id).and_return(@fetcher)
      @fetcher.should_receive(:perform)
      @object.should_receive(:test_method).with(:test_argument).and_return(:test_result)
      @proxy.test_method(:test_argument).should == :test_result
    end

    describe "object" do

      it "should return the original object" do
        GOM::Storage::Fetcher.should_receive(:new).with(@id).and_return(@fetcher)
        @fetcher.should_receive(:perform)
        @proxy.object.should == @object
      end

    end

  end

end
