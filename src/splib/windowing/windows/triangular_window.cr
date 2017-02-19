module Splib
class Window

# Produces a triangular window of a given size (number of samples).
# Endpoints are near zero. Midpoint is one. There is a linear slope between endpoints and midpoint.
# For more info, see https://en.wikipedia.org/wiki/Window_function#Triangular_window
class Triangular < Window
  def produce_data(size)
    a = (size - 1) / 2.0
    Array.new(size) do |n|
      1 - ((n - a) / a).abs
    end
  end
end

end
end
