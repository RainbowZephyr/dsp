require "../../misc/common_math"
require "../permute/radix"

module DSP::Transforms
  class Radix5
    ROOT_FIVE                      = Math.sqrt(5) / 4.0
    TWO_PI_BY_FIVE                 = Math.sin(Math::PI * 2 / 5.0)
    PI_BY_FIVE                     = Math.sin(Math::PI / 5.0)
    PI_BY_FIVE_OVER_TWO_PI_BY_FIVE = PI_BY_FIVE / TWO_PI_BY_FIVE

    def self.fft(input : Array) : Array(Complex)
      return fft_helper(input, true)
    end

    def self.ifft(input : Array) : Array(Complex)
      return fft_helper(input, false).map { |e| e/input.size }
    end

    def self.fft_helper(input : Array, forward? : Bool = true) : Array(Complex)
      if forward?
        complex_input = input.map { |e| e.to_c }
      else
        complex_input = input.map { |e| e.to_c.conj }
      end
      size = input.size
      exponent = Math.log(size, 5)
      if exponent.floor != (exponent.round(12))
        raise ArgumentError.new("Input size #{size} is not power of 5")
      end

      reversed_array = DSP::Permute.radix(complex_input, 5)

      (1..exponent).each do |stride|
        m = 5**stride

        y = Math::PI * 2 / m
        factor1 = Complex.new(Math.cos(y), -Math.sin(y))
        factor2 = Complex.new(Math.cos(y*2), -Math.sin(y*2))
        factor3 = Complex.new(Math.cos(y*3), -Math.sin(y*3))
        factor4 = Complex.new(Math.cos(y*4), -Math.sin(y*4))

        0.step(to: size - 1, by: m) do |k|
          omega1 = 1
          omega2 = 1
          omega3 = 1
          omega4 = 1

          (0...(m//5)).each do |j|
            s0 = reversed_array[k + j]
            s1 = omega1 * reversed_array[k + j + 1 * m // 5]
            s2 = omega2 * reversed_array[k + j + 2 * m // 5]
            s3 = omega3 * reversed_array[k + j + 3 * m // 5]
            s4 = omega4 * reversed_array[k + j + 4 * m // 5]

            d0 = s1 + s4
            d1 = s2 + s3
            d2 = TWO_PI_BY_FIVE * (s1 - s4)
            d3 = TWO_PI_BY_FIVE * (s2 - s3)
            d4 = d0 + d1
            d5 = ROOT_FIVE * (d0 - d1)
            d6 = s0 - (0.25 * d4)
            d7 = d6 + d5
            d8 = d6 - d5
            d9 = -1.i * (d2 + (PI_BY_FIVE_OVER_TWO_PI_BY_FIVE * d3))
            d10 = -1.i * ((PI_BY_FIVE_OVER_TWO_PI_BY_FIVE * d2) - d3)

            reversed_array[k + j] = s0 + d4
            reversed_array[k + j + 1 * m // 5] = (d7 + d9)
            reversed_array[k + j + 2 * m // 5] = (d8 + d10)
            reversed_array[k + j + 3 * m // 5] = (d8 - d10)
            reversed_array[k + j + 4 * m // 5] = (d7 - d9)

            omega1 *= factor1
            omega2 *= factor2
            omega3 *= factor3
            omega4 *= factor4
          end
        end
      end

      return reversed_array
    end
  end
end
