
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
      related_object = @object.instance_variable_get :@related_object
      related_object.should be_instance_of(GOM::Object::Proxy)
      related_object.object.should == @related_object
      related_object.object.instance_variable_get(:@number).should == 16
    end

  end

  describe "storing an object" do

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
      related_object.should == @related_object
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

end
