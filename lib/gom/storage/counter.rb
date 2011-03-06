
# Counts the number of objects in the given storage.
class GOM::Storage::Counter

  def initialize(storage_name)
    @storage_name = storage_name
  end

  def perform
    adapter.count
  end

  private

  def adapter
    @adapter ||= GOM::Storage::Configuration[@storage_name].adapter
  end

end
