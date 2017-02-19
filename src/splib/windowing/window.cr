module Splib

abstract class Window < Array(Float64)
  def initialize(size)
    raise ArgumentError.new("Non-positive window size #{size}") if size <= 0
    data = produce_data(size)
    super(data.size)
    concat(data)
  end

  abstract def produce_data(size)
end

end
