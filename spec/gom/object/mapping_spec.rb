require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "spec_helper"))

describe GOM::Object::Mapping do

  before :each do
    @object = Object.new
    @id = "object_1"
    @mapping = GOM::Object::Mapping.new
  end

  describe "put" do

    it "should store a mapping between an object and an id" do
      @mapping.put @object, @id
      @mapping.object_by_id(@id).should == @object
    end

  end

  describe "with a mapping" do

    before :each do
      @mapping.put @object, @id
    end

    describe "object_by_id" do

      it "should return the object to the given id" do
        @mapping.object_by_id(@id).should == @object
      end

    end

    describe "id_by_object" do

      it "should return the id to the given object" do
        @mapping.id_by_object(@object).should == @id
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

  end

  describe "class method" do

    before :each do
      @object = Object.new
      @id = "object_1"

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

    describe "put" do

      before :each do
        GOM::Object::Mapping.stub!(:singleton).and_return(@mapping)
      end

      it "should call put on the mapping instance" do
        @mapping.should_receive(:put).with(@object, @id)
        GOM::Object::Mapping.put @object, @id
      end

    end

    describe "object_by_id" do

      before :each do
        GOM::Object::Mapping.stub!(:singleton).and_return(@mapping)
      end

      it "should call object_by_id on the mapping instance" do
        @mapping.should_receive(:object_by_id).with(@id).and_return(@object)
        GOM::Object::Mapping.object_by_id(@id).should == @object
      end

    end

    describe "id_by_object" do

      before :each do
        GOM::Object::Mapping.stub!(:singleton).and_return(@mapping)
      end

      it "should call id_by_object on the mapping instance" do
        @mapping.should_receive(:id_by_object).with(@object).and_return(@id)
        GOM::Object::Mapping.id_by_object(@object).should == @id
      end

    end

    describe "remove_by_id" do

      before :each do
        GOM::Object::Mapping.stub!(:singleton).and_return(@mapping)
      end

      it "should call remove_by_id on the mapping instance" do
        @mapping.should_receive(:remove_by_id).with(@id)
        GOM::Object::Mapping.remove_by_id(@id)
      end

    end

    describe "remove_by_object" do

      before :each do
        GOM::Object::Mapping.stub!(:singleton).and_return(@mapping)
      end

      it "should call remove_by_object on the mapping instance" do
        @mapping.should_receive(:remove_by_object).with(@object)
        GOM::Object::Mapping.remove_by_object(@object)
      end

    end

  end

end
