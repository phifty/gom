require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

describe GOM::Object::Proxy do

  describe "initialized with an object" do

    before :each do
      @object = mock Object, :test_method => nil

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

    describe "id" do

      before :each do
        @id = mock GOM::Object::Id
        GOM::Object::Mapping.stub(:id_by_object).and_return(@id)
      end

      it "should fetch the id from the mapping" do
        GOM::Object::Mapping.should_receive(:id_by_object).with(@object).and_return(@id)
        @proxy.id
      end

      it "should return the fetched id" do
        @proxy.id.should == @id
      end

      it "should return nil if no mapping exists" do
        GOM::Object::Mapping.stub(:id_by_object).and_return(nil)
        @proxy.id.should be_nil
      end

    end

  end

  describe "initialized with an id" do

    before :each do
      @id = GOM::Object::Id.new "test_storage", "object_1"

      @object = mock Object, :test_method => nil

      @fetcher = mock GOM::Storage::Fetcher, :object => @object
      GOM::Storage::Fetcher.stub(:new).and_return(@fetcher)

      @proxy = GOM::Object::Proxy.new @id
    end

    it "should fetch the object before the call is passed to it" do
      GOM::Storage::Fetcher.should_receive(:new).with(@id).and_return(@fetcher)
      @fetcher.should_receive(:object).and_return(@object)
      @object.should_receive(:test_method).with(:test_argument).and_return(:test_result)
      @proxy.test_method(:test_argument).should == :test_result
    end

    describe "object" do

      it "should return the original object" do
        GOM::Storage::Fetcher.should_receive(:new).with(@id).and_return(@fetcher)
        @fetcher.should_receive(:object).and_return(@object)
        @proxy.object.should == @object
      end

    end

    describe "id" do

      it "should return the id" do
        @proxy.id.should == @id
      end

    end

  end

end
