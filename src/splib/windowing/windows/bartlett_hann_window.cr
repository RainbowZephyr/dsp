module Splib
class Window

# Produces a Bartlett-Hann window of a given size (number of samples).
# For more info, see https://en.wikipedia.org/wiki/Window_function#Bartlett.E2.80.93Hann_window.
class BartlettHann < Window
  A0 = 0.62
  A1 = 0.48
  A2 = 0.38

  def produce_data(size)
    size_min_1 = (size - 1)

    Array.new(size) do |n|
      x1 = ((n.to_f / size_min_1) - 0.5).abs
      x2 = (TWO_PI * n) / size_min_1
      A0 - A1 * x1 - A2 * Math.cos(x2)
    end
  end
end

end
end
