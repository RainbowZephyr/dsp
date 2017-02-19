module Splib
class Window

# Produces a Lanczos window of a given size (number of samples).
# The Lanczos window is used in Lanczos resampling.
# For more info, see https://en.wikipedia.org/wiki/Window_function#Lanczos_window.
class Lanczos < Window
  def self.sinc(x)
    pi_x = Math::PI * x
    Math.sin(pi_x) / pi_x
  end

  def window(size)
    size_min_1 = (size-1)
    Array.new(size) do |n|
      x = ((2.0*n)/size_min_1) - 1
      if x == 0
        1.0
      else
        pi_x = Math::PI * x
        Math.sin(pi_x) / pi_x # sinc function
      end
    end
  end
end

end
end
