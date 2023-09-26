module DSP
class Window

# Produces a Hamming window of a given size (number of samples).
# For more info, see https://en.wikipedia.org/wiki/Window_function#Hamming_window.
class Hamming < Window
  def window(size)
    alpha = 0.54
    beta = 1.0 - alpha
    size_min_1 = size - 1
    Array.new(size) do |n|
      alpha - (beta * Math.cos((TWO_PI * n) / size_min_1))
    end
  end
end

end
end
