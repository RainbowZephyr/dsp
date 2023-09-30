require "../../misc/common_math"
require "../permute/radix"

module DSP::Transforms
  class Radix8
    ROOT = Math.sqrt(0.5)

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

      exponent = Math.log(size, 8)
      if exponent.floor != exponent
        raise ArgumentError.new("Input size #{size} is not power of 8")
      end

      reversed_array = DSP::Permute.radix(complex_input, 8)

      (1..exponent).each do |stride|
        m = 8**stride

        y = Math::PI * 2 / m
        # sin_mul = forward ? -1.0 : 1.0
        factor1 = Complex.new(Math.cos(y), -Math.sin(y))
        factor2 = Complex.new(Math.cos(y*2), -Math.sin(y*2))
        factor3 = Complex.new(Math.cos(y*3), -Math.sin(y*3))
        factor4 = Complex.new(Math.cos(y*4), -Math.sin(y*4))
        factor5 = Complex.new(Math.cos(y*5), -Math.sin(y*5))
        factor6 = Complex.new(Math.cos(y*6), -Math.sin(y*6))
        factor7 = Complex.new(Math.cos(y*7), -Math.sin(y*7))

        0.step(to: size - 1, by: m) do |k|
          omega1 = 1
          omega2 = 1
          omega3 = 1
          omega4 = 1
          omega5 = 1
          omega6 = 1
          omega7 = 1

          (0...(m//8)).each do |j|
            s0 = reversed_array[k + j]
            s1 = omega1 * reversed_array[k + j + 1 * m // 8]
            s2 = omega2 * reversed_array[k + j + 2 * m // 8]
            s3 = omega3 * reversed_array[k + j + 3 * m // 8]
            s4 = omega4 * reversed_array[k + j + 4 * m // 8]
            s5 = omega5 * reversed_array[k + j + 5 * m // 8]
            s6 = omega6 * reversed_array[k + j + 6 * m // 8]
            s7 = omega7 * reversed_array[k + j + 7 * m // 8]

            d0 = s0 + s4
            d1 = s0 - s4
            d2 = s2 + s6
            d3 = -1.i * (s2 - s6)
            d4 = s1 + s5
            d5 = s1 - s5
            d6 = s3 + s7
            d7 = s3 - s7

            e0 = d0 + d2
            e1 = d0 - d2
            e2 = d4 + d6
            e3 = -1.i * (d4 - d6)
            e4 = ROOT * (d5 - d7)
            e5 = -ROOT.i * (d5 + d7)
            e6 = (d1 + e4)
            e7 = d1 - e4
            e8 = d3 + e5
            e9 = d3 - e5

            reversed_array[k + j] = e0 + e2
            reversed_array[k + j + 1 * m // 8] = (e6 + e8)
            reversed_array[k + j + 2 * m // 8] = (e1 + e3)
            reversed_array[k + j + 3 * m // 8] = (e7 - e9)
            reversed_array[k + j + 4 * m // 8] = (e0 - e2)
            reversed_array[k + j + 5 * m // 8] = (e7 + e9)
            reversed_array[k + j + 6 * m // 8] = (e1 - e3)
            reversed_array[k + j + 7 * m // 8] = (e6 - e8)

            omega1 *= factor1
            omega2 *= factor2
            omega3 *= factor3
            omega4 *= factor4
            omega5 *= factor5
            omega6 *= factor6
            omega7 *= factor7
          end
        end
      end

      return reversed_array
    end
  end
end
