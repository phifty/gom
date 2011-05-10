require File.expand_path(File.join(File.dirname(__FILE__), "..", "spec_helper"))

describe "fake adapter" do

  it_should_behave_like "an adapter that needs setup"

  it_should_behave_like "an adapter connected to a stateful storage"

end
