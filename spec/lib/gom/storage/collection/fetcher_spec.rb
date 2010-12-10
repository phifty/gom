require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "..", "spec_helper"))

describe GOM::Storage::Collection::Fetcher do

  before :each do
    @fetcher = described_class.new
  end

  describe "objects_or_ids" do

    it "should raise a #{NotImplementedError}" do
      lambda do
        @fetcher.objects_or_ids
      end.should raise_error(NotImplementedError)
    end

  end

end
