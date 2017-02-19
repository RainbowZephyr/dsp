module Splib
class Window

# Produces a Cosine window of a given size (number of samples).
# For more info, see https://en.wikipedia.org/wiki/Window_function#Cosine_window.
class Cosine < Window
  def produce_data(size)
    size_min_1 = size - 1
    Array.new(size) do |n|
      Math.sin((Math::PI * n) / size_min_1)
    end
  end
end

end
end
