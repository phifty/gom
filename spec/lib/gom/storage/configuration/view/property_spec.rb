require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "..", "..", "spec_helper"))

describe GOM::Storage::Configuration::View::Property do

  before :each do
    @view = described_class.new "filter", "properties"
  end

  describe "initialize" do

    it "should set the filter" do
      filter = @view.filter
      filter.should == "filter"
    end

    it "should set the properties" do
      properties = @view.properties
      properties.should == "properties"
    end

  end

end
