require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "..", "..", "spec_helper"))

describe GOM::Storage::Configuration::View::MapReduce do

  before :each do
    @view = described_class.new "map function", "reduce function"
  end

  describe "initialize" do

    it "should set the view's map function" do
      @view.map.should == "map function"
    end

    it "should set the view's reduce function" do
      @view.reduce.should == "reduce function"
    end

  end

end
