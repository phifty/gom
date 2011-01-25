
shared_examples_for "an adapter connected to a stateful storage" do

  before :all do
    GOM::Storage.setup
  end

  before :each do
    @related_object = GOM::Spec::Object.new
    @related_object.number = 16

    @object = GOM::Spec::Object.new
    @object.number = 11
    @object.related_object = GOM::Object.reference @related_object
  end

  describe "fetching an object" do

    before :each do
      GOM::Storage.store @object, :test_storage
      @id = GOM::Object.id @object

      @object = GOM::Storage.fetch @id
    end

    after :each do
      GOM::Storage.remove @related_object
      GOM::Storage.remove @object
    end

    it "should return an object of the correct class" do
      @object.class.should == GOM::Spec::Object
    end

    it "should set the object's instance variables" do
      @object.number.should == 11
    end

    it "should assign an object id" do
      GOM::Object.id(@object).should == @id
    end

    it "should also fetch the related object" do
      related_object_proxy = @object.related_object
      related_object_proxy.should be_instance_of(GOM::Object::Proxy)
      # draft = GOM::Storage::Configuration.default.adapter.fetch related_object_proxy.id.object_id
      # puts "DRAFT ::: " + draft.inspect
      related_object_proxy.object.number.should == 16
    end

  end

  describe "storing an object" do

    after :each do
      GOM::Storage.remove @related_object
      GOM::Storage.remove @object
    end

    it "should store the object" do
      GOM::Storage.store @object, :test_storage
      object = GOM::Storage.fetch GOM::Object.id(@object)
      object.should == @object
    end

    it "should use default storage if nothing specified" do
      GOM::Storage.store @object
      GOM::Object.id(@object).should =~ /^test_storage:/
    end

    it "should set the object's id" do
      GOM::Storage.store @object, :test_storage
      GOM::Object.id(@object).should =~ /^test_storage:.+$/
    end

    it "should store the related object" do
      GOM::Storage.store @object, :test_storage
      related_object = GOM::Storage.fetch GOM::Object.id(@related_object)
      related_object.number.should == 16
    end

  end

  describe "removing an object" do

    before :each do
      GOM::Storage.store @object, :test_storage
      @id = GOM::Object.id @object
    end

    after :each do
      GOM::Storage.remove @related_object
    end

    it "should remove the object" do
      GOM::Storage.remove @object
      GOM::Storage.fetch(@id).should be_nil
    end

    it "should remove the object identified by the id" do
      GOM::Storage.remove @id
      GOM::Storage.fetch(@id).should be_nil
    end

    it "should remove the object's id" do
      GOM::Storage.remove @object
      GOM::Object.id(@object).should be_nil
    end

    it "should not remove the related object" do
      GOM::Storage.remove @object
      GOM::Object.id(@related_object).should_not be_nil
    end

  end

  describe "fetching a class collection" do

    before :each do
      @another_object = Object.new
      @another_object.instance_variable_set :@number, 17

      GOM::Storage.store @object, :test_storage
      GOM::Storage.store @another_object, :test_storage
    end

    after :each do
      GOM::Storage.remove @another_object
      GOM::Storage.remove @related_object
      GOM::Storage.remove @object
    end

    it "should provide a collection of the class view" do
      collection = GOM::Storage.collection :test_storage, :test_object_class_view
      collection.should be_instance_of(GOM::Object::Collection)
    end

    it "should provide a collection of all objects of the class from a class view" do
      collection = GOM::Storage.collection :test_storage, :test_object_class_view
      collection.size.should > 0
      collection.each do |object_proxy|
        object_proxy.should be_instance_of(GOM::Object::Proxy)
        [ @object.number, @related_object.number ].should include(object_proxy.number)
        [ @another_object.instance_variable_get(:@number) ].should_not include(object_proxy.instance_variable_get(:@number))
      end
    end

  end

  describe "fetching a map collection" do

    before :each do
      GOM::Storage.store @object, :test_storage
    end

    after :each do
      GOM::Storage.remove @related_object
      GOM::Storage.remove @object
    end

    it "should provide a collection" do
      collection = GOM::Storage.collection :test_storage, :test_map_view
      collection.should be_instance_of(GOM::Object::Collection)
    end

    it "should provide a collection of the objects emitted by the map reduce view" do
      collection = GOM::Storage.collection :test_storage, :test_map_view
      collection.size.should > 0
      collection.each do |object_proxy|
        object_proxy.should be_instance_of(GOM::Object::Proxy)
        object_proxy.object.number.should == @object.number
      end
    end

  end

end
