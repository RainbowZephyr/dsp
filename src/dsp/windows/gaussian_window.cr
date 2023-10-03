require "./window"

module DSP::Windows
  # Produces a Gaussian window of a given size (number of samples).
  # For more info, see https://en.wikipedia.org/wiki/Window_function#Gaussian_windows.
  class Gaussian < Window
    SIGMA_RANGE = 0.0..0.5

    def self.get(size, sigma = 0.4)
      unless SIGMA_RANGE.includes?(sigma)
        raise ArgumentError.new("sigma #{sigma} not in range #{SIGMA_RANGE}")
      end
      size_min_1_over_2 = (size - 1) / 2.0
      Array.new(size) do |n|
        a = (n - size_min_1_over_2) / (sigma * size_min_1_over_2)
        Math.exp(-0.5 * a**2)
      end
    end
  end
end
