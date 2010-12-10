require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

describe GOM::Object::Collection do

  before :each do
    @object = mock Object
    @objects = [ @object ]
    @fetcher = mock GOM::Storage::Collection::Fetcher, :total_count => 1, :objects_or_ids => @objects

    @collection = described_class.new @fetcher
  end

  describe "total_count" do

    it "should call the fetcher's total_count" do
      @fetcher.should_receive(:total_count)
      @collection.total_count
    end

  end

  describe "first" do

    context "with no previous fetched objects" do

      it "should call the fetcher" do
        @fetcher.should_receive(:objects_or_ids).and_return(@objects)
        @collection.first
      end

      it "should return a object proxy for the first object" do
        object_proxy = @collection.first
        object_proxy.should be_instance_of(GOM::Object::Proxy)
        object_proxy.object.should == @object
      end

    end

    context "with previously fetched objects" do

      before :each do
        @collection.first
      end

      it "should not call the fetcher" do
        @fetcher.should_not_receive(:objects_or_ids)
        @collection.first
      end

      it "should return a object proxy for the first object" do
        object_proxy = @collection.first
        object_proxy.should be_instance_of(GOM::Object::Proxy)
        object_proxy.object.should == @object
      end

    end

  end

end
