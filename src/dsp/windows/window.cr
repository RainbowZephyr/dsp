module DSP::Windows
  # A The output of some kind of window function
  # https://en.wikipedia.org/wiki/Window_function
  abstract class Window
    # Default case of no window applied
    def self.get(size) : Array(Float64)
      return Array(Float64).new(size, 1.0)
    end
  end
end
