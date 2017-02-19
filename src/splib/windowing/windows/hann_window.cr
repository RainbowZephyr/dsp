module Splib
class Window

# Produces a Hann window of a given size (number of samples).
# For more info, see https://en.wikipedia.org/wiki/Window_function#Hann_.28Hanning.29_window.
class Hann < Window
  def produce_data(size)
    size_min_1 = size - 1
    Array.new(size) do |n|
      0.5 * (1 - Math.cos((TWO_PI * n)/size_min_1))
    end
  end
end

end
end
