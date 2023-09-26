module DSP::Transforms
  class DFT
    def self.fft(input : Array) : Array(Complex)
      return fft_helper(input, true)
    end

    def self.ifft(input : Array) : Array(Complex)
      return fft_helper(input, false).map { |e| e/input.size }
    end

    def self.fft_helper(input : Array, forward? : Bool) : Array(Complex)
      f = Array(Complex).new(input.size, Complex.new(0, 0))
      k = 0
      sin_mul = forward? ? -1.0 : 1.0
      
      while k < input.size
        n = 0
        sum : Complex = Complex.new(0, 0)
        while n < input.size
          y = Math::PI * 2 * k * n / input.size
          factor = Complex.new(Math.cos(y), sin_mul * Math.sin(y))
          sum += input[n] * factor
          n += 1
        end
        f[k] = sum
        k += 1
      end

      return f
    end
  end
end
