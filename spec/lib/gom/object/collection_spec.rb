require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

describe GOM::Object::Collection do

  before :each do
    @object = mock Object

    @fetcher = mock Object, :total_count => 1

    @proxy = mock GOM::Object::Proxy
    GOM::Object::Proxy.stub(:new).and_return(@proxy)

    @builder = mock GOM::Object::CachedBuilder, :object => @object
    GOM::Object::CachedBuilder.stub(:new).and_return(@builder)

    @collection = described_class.new @fetcher, "test_storage"
  end

  describe "total_count" do

    it "should call the fetcher's total_count" do
      @fetcher.should_receive(:total_count)
      @collection.total_count
    end

  end

  describe "first" do

    context "with no previous fetched objects" do

      context "with a fetcher that provides drafts" do

        before :each do
          @draft = mock Hash
          @drafts = [ @draft ]

          @fetcher.stub(:drafts).and_return(@drafts)
        end

        it "should get the drafts from the fetcher" do
          @fetcher.should_receive(:drafts).and_return(@drafts)
          @collection.first
        end

        it "should initialize the cached object builder with each draft" do
          GOM::Object::CachedBuilder.should_receive(:new).with(@draft, "test_storage").and_return(@builder)
          @collection.first
        end

        it "should initialize an object proxy with the object" do
          GOM::Object::Proxy.should_receive(:new).with(@object).and_return(@proxy)
          @collection.first
        end

        it "should return a object proxy for the first object" do
          object_proxy = @collection.first
          object_proxy.should == @proxy
        end

      end

      context "with a fetcher that provides ids" do

        before :each do
          @id = mock GOM::Object::Id
          @ids = [ @id ]

          @fetcher.stub(:ids).and_return(@ids)
        end

        it "should get the ids from the fetcher" do
          @fetcher.should_receive(:ids).and_return(@ids)
          @collection.first
        end

        it "should not initialize the cached object builder" do
          GOM::Object::CachedBuilder.should_not_receive(:new)
          @collection.first
        end

        it "should initialize an object proxy with the id" do
          GOM::Object::Proxy.should_receive(:new).with(@id).and_return(@proxy)
          @collection.first
        end

        it "should return a object proxy for the first object" do
          object_proxy = @collection.first
          object_proxy.should == @proxy
        end

      end

      context "with a fetcher that provide rows" do

        before :each do
          @row = mock Object
          @rows = [ @row ]

          @fetcher.stub(:drafts).and_return(nil)
          @fetcher.stub(:rows).and_return(@rows)
        end

        it "should get the rows from the fetcher" do
          @fetcher.should_receive(:rows).and_return(@rows)
          @collection.first
        end

        it "should not initialize the cached object builder" do
          GOM::Object::CachedBuilder.should_not_receive(:new)
          @collection.first
        end

        it "should return the first row" do
          row = @collection.first
          row.should == @row
        end

      end

      context "with a fetcher that doesn't provide drafts, ids nor rows" do

        it "should raise a #{NotImplementedError}" do
          lambda do
            @collection.first
          end.should raise_error(NotImplementedError)
        end

      end

    end

    context "with previously fetched objects" do

      before :each do
        @draft = mock Hash
        @drafts = [ @draft ]

        @fetcher.stub(:drafts).and_return(@drafts)

        @collection.first
      end

      it "should not call the fetcher" do
        @fetcher.should_not_receive(:drafts)
        @collection.first
      end

      it "should return a object proxy for the first object" do
        object_proxy = @collection.first
        object_proxy.should == @proxy
      end

    end

  end

end
