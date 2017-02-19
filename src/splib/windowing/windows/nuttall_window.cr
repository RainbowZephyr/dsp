module Splib
class Window

# Produces a Nuttall window of a given size (number of samples).
# For more info, see https://en.wikipedia.org/wiki/Window_function#Nuttall_window.2C_continuous_first_derivative.
class Nuttall < Window
  A0 = 0.355768
  A1 = 0.487396
  A2 = 0.144232
  A3 = 0.012604

  def produce_data(size)
    size_min_1 = size - 1
    Array.new(size) do |n|
      x1 = (TWO_PI * n)/size_min_1
      x2 = (FOUR_PI * n)/size_min_1
      x3 = (SIX_PI * n)/size_min_1
      A0 - A1 * Math.cos(x1) + A2 * Math.cos(x2) - A3 * Math.cos(x3)
    end
  end
end

end
end
