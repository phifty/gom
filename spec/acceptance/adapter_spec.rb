require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

GOM::Storage::Configuration.read File.join(File.dirname(__FILE__), "..", "storage.configuration")

describe "adapter" do

  before :each do
    GOM::Storage.teardown
  end

  describe "setup" do

    it "should raise a #{GOM::Storage::AdapterNotFoundError} if no adapter of that name is registered" do
      GOM::Storage::Configuration[:test_storage].hash[:adapter] = "invalid"
      lambda do
        GOM::Storage.setup
      end.should raise_error(GOM::Storage::AdapterNotFoundError)
    end

  end

end