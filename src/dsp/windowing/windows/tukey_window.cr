module DSP
class Window

# Produces a Tukey window of a given size (number of samples).
# The Tukey window, also known as tapered cosine, can be regarded as a cosine
# lobe of width alpha * N / 2 that is convolved with a rectangular window. At
# alpha = 0 it becomes rectangular, and at alpha = 1 it becomes a Hann window.
# For more info, see https://en.wikipedia.org/wiki/Window_function#Tukey_window.
class Tukey < Window
  ALPHA_RANGE = (0.0..1.0)

  def initialize(size, @alpha = 0.5)
    unless ALPHA_RANGE.includes?(@alpha)
      raise ArgumentError.new("alpha #{@alpha} not in range #{ALPHA_RANGE}")
    end
    super(size)
  end

  def window(size)
    size_min_1 = size - 1
    left = (@alpha * (size - 1) / 2.0).to_i
    right = size_min_1 - left  # ((size - 1) * (1.0 - (@alpha / 2.0))).ceil.to_i

    Array.new(size) do |n|
      if n < left
        x = Math::PI * (((2.0 * n) / (@alpha * size_min_1)) - 1.0)
        0.5 * (1.0 + Math.cos(x))
      elsif n <= right
        1.0
      else
        x = Math::PI * (((2 * n) / (@alpha * size_min_1)) - (2.0 / @alpha) + 1.0)
        0.5 * (1.0 + Math.cos(x))
      end
    end
  end
end

end
end
