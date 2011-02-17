
# Contains all parameters for a map reduce view.
class GOM::Storage::Configuration::View::MapReduce

  attr_accessor :map
  attr_accessor :reduce

  def initialize(map, reduce)
    @map, @reduce = map, reduce
  end

end