module DSP

# A The output of some kind of window function
# https://en.wikipedia.org/wiki/Window_function
abstract class Window < Array(Float64)
  def initialize(size)
    raise ArgumentError.new("Non-positive window size #{size}") if size <= 0
    data = window(size)
    super(data.size)
    concat(data)
  end

  abstract def window(size)
end

end
