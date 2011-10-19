require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "..", "..", "spec_helper"))

describe GOM::Storage::Configuration::View::Search do

  before :each do
    @view = described_class.new [ "Object" ]
  end

  describe "initialize" do

    it "should set the view's class name" do
      @view.class_name.should == [ "Object" ]
    end

  end

end
