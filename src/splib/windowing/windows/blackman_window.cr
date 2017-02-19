module Splib
class Window

# Produces a Blackman window of a given size (number of samples).
# For more info, see https://en.wikipedia.org/wiki/Window_function#Blackman_windows.
class Blackman < Window
  ALPHA = 0.16
  A0 = (1 - ALPHA) / 2.0
  A1 = 0.5
  A2 = ALPHA / 2.0

  def produce_data(size)
    size_min_1 = size - 1

    Array.new(size) do |n|
      x1 = (TWO_PI * n) / size_min_1
      x2 = (FOUR_PI * n) / size_min_1
      A0 - A1 * Math.cos(x1) + A2 * Math.cos(x2)
    end
  end
end

end
end
