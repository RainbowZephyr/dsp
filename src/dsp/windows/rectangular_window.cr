require "./window"

module DSP::Windows
  # Produces a rectangular window (all ones) of a given size (number of samples).
  # For more info, see https://en.wikipedia.org/wiki/Window_function#Rectangular_window.
  class Rectangular < Window
    def self.get(size)
      [1.0] * size
    end
  end
end
