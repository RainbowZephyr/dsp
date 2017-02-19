module Splib
class Window

# Produces a Blackman-Harris window of a given size (number of samples).
# For more info, see https://en.wikipedia.org/wiki/Window_function#Blackman.E2.80.93Harris_window.
class BlackmanHarris < Window
  A0 = 0.35875
  A1 = 0.48829
  A2 = 0.14128
  A3 = 0.01168

  def window(size)
    size_min_1 = size - 1

    Array.new(size) do |n|
      x1 = (TWO_PI * n)/ size_min_1
      x2 = (FOUR_PI * n)/ size_min_1
      x3 = (SIX_PI * n)/ size_min_1
      A0 - A1 * Math.cos(x1) + A2 * Math.cos(x2) - A3 * Math.cos(x3)
    end
  end
end

end
end
