
shared_examples_for "an adapter with search view" do

  before :all do
    GOM::Storage.setup
  end

  after :all do
    GOM::Storage.teardown
  end

  before :each do
    @object_one = GOM::Spec::Object.new
    @object_one.number = 11

    @object_two = GOM::Spec::Object.new
    @object_two.number = 24

    @object_three = Object.new
    @object_three.instance_variable_set :@number, 11
  end

  describe "fetching a search collection" do

    before :each do
      GOM::Storage.store @object_one, :test_storage
      GOM::Storage.store @object_two, :test_storage

      sleep 1.0 # wait until changes go through the river in the index
    end

    after :each do
      GOM::Storage.remove @object_one
      GOM::Storage.remove @object_two
    end

    it "should return the right results" do
      collection = GOM::Storage.collection :test_storage, :test_search_view, :query => "11"
      collection.should be_instance_of(GOM::Object::Collection)
      collection.size.should == 1
      collection.map(&:class).should == [ GOM::Spec::Object ]
      collection.map(&:number).should == [ 11 ]
    end

  end

end