require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

describe GOM::Object::Mapping do

  before :each do
    @object = Object.new
    @id = GOM::Object::Id.new "test_storage", "object_1"
    @mapping = GOM::Object::Mapping.new
  end

  describe "put" do

    it "should store a mapping between an object and an id" do
      @mapping.put @object, @id
      @mapping.object_by_id(@id).should == @object
    end

    it "should not store anything if object is nil" do
      lambda do
        @mapping.put nil, @id
      end.should_not change(@mapping, :size)
    end

    it "should not store anything if id is nil" do
      lambda do
        @mapping.put @object, nil
      end.should_not change(@mapping, :size)
    end

  end

  describe "with a mapping" do

    before :each do
      @same_id = GOM::Object::Id.new @id.storage_name, @id.object_id
      @mapping.put @object, @id
    end

    describe "object_by_id" do

      it "should return the object to the given id" do
        @mapping.object_by_id(@id).should == @object
      end

      it "should return the object for a different id with the same attributes" do
        @mapping.object_by_id(@same_id).should == @object
      end

    end

    describe "id_by_object" do

      it "should return the id to the given object" do
        @mapping.id_by_object(@object).should == @id
        @mapping.id_by_object(@object).should == @same_id
      end

    end

    describe "remove_by_id" do

      it "should remove the mapping identified by id" do
        @mapping.remove_by_id @id
        @mapping.object_by_id(@id).should be_nil
      end

    end

    describe "remove_by_object" do

      it "should remove the mapping identified by object" do
        @mapping.remove_by_object @object
        @mapping.id_by_object(@object).should be_nil
      end

    end

    describe "size" do

      it "should return the number of mapping entries" do
        @mapping.size.should == 1
      end

    end

    describe "clear!" do

      it "should remove all mappings" do
        @mapping.clear!
        @mapping.size.should == 0
      end

    end

    describe "inspect" do

      it "should return a string with all the mappings" do
        output = @mapping.inspect
        output.should =~ /#<Object:.*> => test_storage:object_1\n/
      end

    end

  end

  describe "class method" do

    before :each do
      @object = Object.new
      @id = GOM::Object::Id.new "test_storage", "object_1"

      @mapping = Object.new
      @mapping.stub!(:put)
      @mapping.stub!(:object_by_id).and_return(@object)
      @mapping.stub!(:id_by_object).and_return(@id)
    end

    describe "singleton" do

      before :each do
        GOM::Object::Mapping.stub!(:new).and_return(@mapping)
      end

      it "should initialize just one mapping instance" do
        GOM::Object::Mapping.should_receive(:new).once.and_return(@mapping)
        GOM::Object::Mapping.singleton
        GOM::Object::Mapping.singleton
      end

    end

    [ :put, :object_by_id, :id_by_object, :remove_by_id, :remove_by_object, :size ].each do |method_name|

      describe "put" do

        before :each do
          GOM::Object::Mapping.stub(:singleton).and_return(@mapping)
        end

        it "should call #{method_name} on the mapping instance" do
          @mapping.should_receive(method_name).with(:argument).and_return(:result)
          result = GOM::Object::Mapping.send method_name, :argument
          result.should == :result
        end

      end

    end

  end

end
