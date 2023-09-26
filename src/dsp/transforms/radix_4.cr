require "../../misc/common_math"
require "../permute/radix"

module DSP::Transforms
  class Radix4
    TWO_PI = Math::PI * 2.0

    def self.fft(input : Array) : Array(Complex)
      return fft_helper(input, true)
    end

    def self.ifft(input : Array) : Array(Complex)
      return fft_helper(input, false).map{|e| e/input.size}
    end

    def self.fft_helper(waveform : Array, forward : Bool = true) : Array(Complex)
      complex_input = waveform.map { |e| e.to_c }
      size = waveform.size
      exponent = Math.log(size, 4)
      if exponent.floor != exponent
        raise ArgumentError.new("Input size #{size} is not power of 4")
      end

      reversed_array = DSP::Permute.radix(complex_input, 4)

      sin_mul = forward ? -1.0 : 1.0
      (1..exponent).each do |stride|
        m = 4**stride

        y = Math::PI * 2 / m
        factor1 = Complex.new(Math.cos(y), sin_mul * Math.sin(y))
        factor2 = Complex.new(Math.cos(y*2), sin_mul * Math.sin(y*2))
        factor3 = Complex.new(Math.cos(y*3), sin_mul * Math.sin(y*3))

        0.step(to: size - 1, by: m) do |k|
          omega1 = 1
          omega2 = 1
          omega3 = 1

          (0...(m//4)).each do |j|
            s0 = reversed_array[k + j]
            s1 = omega1 * reversed_array[k + j + 1 * m // 4]
            s2 = omega2 * reversed_array[k + j + 2 * m // 4]
            s3 = omega3 * reversed_array[k + j + 3 * m // 4]

            d0 = s0 + s2
            d1 = s0 - s2
            d2 = s1 + s3
            d3 = -1.i * (s1 - s3)

            reversed_array[k + j] = d0 + d2
            reversed_array[k + j + 1 * m // 4] = (d1 + d3) # * omega1
            reversed_array[k + j + 2 * m // 4] = (d0 - d2) # * omega2
            reversed_array[k + j + 3 * m // 4] = (d1 - d3) # * omega3

            omega1 *= factor1
            omega2 *= factor2
            omega3 *= factor3
          end
        end
      end

      return reversed_array
    end
  end
end
