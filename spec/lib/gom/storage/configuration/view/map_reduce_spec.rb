require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "..", "..", "spec_helper"))

describe GOM::Storage::Configuration::View::MapReduce do

  before :each do
    @map_reduce = described_class.new "javascript", "map function", "reduce function"
  end

  describe "initialize" do

    it "should set the view's language" do
      @map_reduce.language.should == "javascript"
    end

    it "should set the view's map function" do
      @map_reduce.map.should == "map function"
    end

    it "should set the view's reduce function" do
      @map_reduce.reduce.should == "reduce function"
    end

  end

end
