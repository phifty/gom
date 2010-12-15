require File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "..", "..", "spec_helper"))

describe GOM::Storage::Collection::Fetcher do

  before :each do
    @fetcher = described_class.new
  end

  [ :object_hashes, :ids ].each do |method_name|

    describe "#{method_name}" do

      it "should raise a #{NotImplementedError}" do
        lambda do
          @fetcher.send method_name
        end.should raise_error(NotImplementedError)
      end

    end

  end

end
