
shared_examples_for "an adapter connected to a stateful storage" do

  before :all do
    GOM::Storage.setup
  end

  before :each do
    @related_object = Object.new
    @related_object.instance_variable_set :@number, 16

    @object = Object.new
    @object.instance_variable_set :@number, 11
    @object.instance_variable_set :@related_object, GOM::Object.reference(@related_object)
  end

  describe "fetching an object" do

    before :each do
      GOM::Storage.store @object, :test_storage
      @id = GOM::Object.id(@object)

      @object = GOM::Storage.fetch @id
    end

    after :each do
      GOM::Storage.remove @related_object
      GOM::Storage.remove @object
    end

    it "should return an object of the correct class" do
      @object.class.should == Object
    end

    it "should set the object's instance variables" do
      @object.instance_variable_get(:@number).should == 11
    end

    it "should assign an object id" do
      GOM::Object.id(@object).should == @id
    end

    it "should also fetch the related object" do
      related_object_proxy = @object.instance_variable_get :@related_object
      related_object_proxy.should be_instance_of(GOM::Object::Proxy)
      related_object_proxy.object.instance_variable_get(:@number).should == 16
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
      related_object.instance_variable_get(:@number).should == 16
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
      @another_object = mock Object, :class => mock(Class, :to_s => "Test")
      @another_object.instance_variable_set :@number, 17

      GOM::Storage.store @object, :test_storage
      GOM::Storage.store @another_object, :test_storage
    end

    after :each do
      GOM::Storage.remove @another_object
      GOM::Storage.remove @related_object
      GOM::Storage.remove @object
    end

    it "should get a collection from a class view" do
      collection = GOM::Storage.collection :test_storage, :test_object_class_view
      collection.should be_instance_of(GOM::Object::Collection)
    end

    it "should get a collection of all objects of the class from a class view" do
      collection = GOM::Storage.collection :test_storage, :test_object_class_view
      collection.each do |object_proxy|
        object_proxy.should be_instance_of(GOM::Object::Proxy)
        [
          @object.instance_variable_get(:@number),
          @related_object.instance_variable_get(:@number)
        ].should include(object_proxy.object.instance_variable_get(:@number))
        [
          @another_object.instance_variable_get(:@number)
        ].should_not include(object_proxy.object.instance_variable_get(:@number))
      end
    end

  end

end
