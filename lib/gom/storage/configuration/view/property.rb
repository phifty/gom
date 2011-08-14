
# Contains all parameters to describe a property view.
class GOM::Storage::Configuration::View::Property

  attr_accessor :filter
  attr_accessor :properties

  def initialize(filter, properties)
    @filter, @properties = filter, properties
  end

end
