require "../../misc/common_math"
require "../permute/radix"

module DSP::Transforms
  class Radix3
    TWO_PI      = Math::PI * 2.0
    PI_BY_THREE = Math.sin(Math::PI / 3)

    def self.fft(input : Array) : Array(Complex)
      return fft_helper(input, true)
    end

    def self.ifft(input : Array(Complex)) : Array(Complex)
      return fft_helper(input, false).map { |e| e/input.size }
    end

    def self.fft_helper(input : Array, forward? : Bool = true) : Array(Complex)
      if forward?
        complex_input = input.map { |e| e.to_c }
      else
        complex_input = input.map { |e| e.to_c.conj }
      end
      size = input.size
      exponent = Math.log(size, 3)
      if exponent.floor != exponent
        raise ArgumentError.new("Input size #{size} is not power of 3")
      end

      reversed_array = DSP::Permute.radix(complex_input, 3)

      # sin_mul = forward ? -1.0 : 1.0
      (1..exponent).each do |stride|
        m = 3**stride

        y = Math::PI * 2 / m
        factor1 = Complex.new(Math.cos(y), -Math.sin(y))
        factor2 = Complex.new(Math.cos(y*2), -Math.sin(y*2))

        0.step(to: size - 1, by: m) do |k|
          omega1 = 1
          omega2 = 1

          (0...(m//3)).each do |j|
            s0 = reversed_array[k + j]
            s1 = omega1 * reversed_array[k + j + 1 * m // 3]
            s2 = omega2 * reversed_array[k + j + 2 * m // 3]

            d0 = s1 + s2
            d1 = s0 - (0.5 * d0)
            d2 = -1.i * PI_BY_THREE * (s1 - s2)

            reversed_array[k + j] = s0 + d0
            reversed_array[k + j + 1 * m // 3] = (d1 + d2) # * omega1
            reversed_array[k + j + 2 * m // 3] = (d1 - d2) # * omega2

            omega1 *= factor1
            omega2 *= factor2
          end
        end
      end

      return reversed_array
    end
  end
end
