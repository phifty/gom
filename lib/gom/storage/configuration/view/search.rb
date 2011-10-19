
# Contains all the parameters for a search view.
class GOM::Storage::Configuration::View::Search

  attr_accessor :class_name

  def initialize(class_name)
    @class_name = class_name
  end

end
