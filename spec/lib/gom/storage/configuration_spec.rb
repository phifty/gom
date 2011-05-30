require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper"))

describe GOM::Storage::Configuration do

  before :each do
    @adapter = mock GOM::Storage::Adapter, :setup => nil
    @adapter_class = mock Class, :new => @adapter
    GOM::Storage::Adapter.stub :[] => @adapter_class

    described_class.configure {
      storage {
        name :test_storage
        adapter :test
        view {
          name :test_object_class_view
          kind :class
          model_class Object
        }
        view {
          name :test_map_view
          kind :map_reduce
          map_function "function(document) { }"
          reduce_function "function(key, values) { }"
        }
      }
    }
    @configuration = described_class[:test_storage]
  end

  describe "#setup" do

    it "should call setup on the adapter instance" do
      @adapter.should_receive(:setup)
      @configuration.setup
    end

  end

  describe "#teardown" do

    it "should call teardown on the adapter instance" do
      @adapter.should_receive(:teardown)
      @configuration.teardown
    end

  end

  describe "#adapter_class" do

    it "should fetch the right adapter class" do
      GOM::Storage::Adapter.should_receive(:[]).with(:test).and_return(@adapter_class)
      @configuration.adapter_class
    end

    it "should return the adapter class" do
      adapter_class = @configuration.adapter_class
      adapter_class.should == @adapter_class
    end

    it "should raise a #{GOM::Storage::AdapterNotFoundError} if adapter name is invalid" do
      GOM::Storage::Adapter.stub(:[]).and_return(nil)
      lambda do
        @configuration.adapter_class
      end.should raise_error(GOM::Storage::AdapterNotFoundError)
    end

  end

  describe "#[]" do

    it "should return the configuration value" do
      @configuration[:name].should == :test_storage
    end

  end

  describe "#values_at" do

    it "should return multiple configuration values" do
      @configuration.values_at(:adapter, :name).should == [ :test, :test_storage ]
    end

  end

  describe "#self.configure" do

    before :each do
      @block = Proc.new { }
      @configuration = { :storage => { :name => :test } }
      Configure.stub :process => @configuration
    end

    it "should pass the given block to Configure.process along with the configuration schema" do
      Configure.should_receive(:process).with(described_class::SCHEMA, &@block).and_return(@configuration)
      described_class.configure &@block
    end

  end

  describe "#self.views" do

    it "should return a hash including class views" do
      view = @configuration.views[:test_object_class_view]
      view.should be_instance_of(described_class::View::Class)
      view.class_name.should == Object
    end

    it "should return a hash including map reduce views" do
      view = @configuration.views[:test_map_view]
      view.should be_instance_of(described_class::View::MapReduce)
      view.map.should == "function(document) { }"
      view.reduce.should == "function(key, values) { }"
    end

    it "should raise a #{NotImplementedError} if the view type is invalid" do
      @configuration["view"] << { :name => "test", :kind => "invalid" }
      lambda do
        @configuration.views[:test_invalid_view]
      end.should raise_error(NotImplementedError)
    end

    it "should return nil if given view name doesn't exists" do
      view = @configuration.views[:invalid]
      view.should be_nil
    end

  end

  describe "#self.setup_all" do

    before :each do
      @configuration.stub(:setup)
    end

    it "should call setup on each configuration" do
      @configuration.should_receive(:setup)
      described_class.setup_all
    end

  end

  describe "#self.teardown_all" do

    before :each do
      @configuration.stub(:teardown)
    end

    it "should call teardown on each configuration" do
      @configuration.should_receive(:teardown)
      described_class.teardown_all
    end

  end

  describe "#self.default" do

    it "should select the first configuration" do
      described_class.default.should == GOM::Storage::Configuration[:test_storage]
    end

    it "should raise StandardError if no configuration loaded" do
      described_class.instance_variable_set :@configurations, { }
      lambda do
        described_class.default
      end.should raise_error(StandardError)
    end

  end

end
