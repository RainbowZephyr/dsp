require "../../misc/common_math"
require "../permute/radix"

module DSP::Transforms
  class Radix2
    TWO_PI = Math::PI * 2

    def self.fft(input : Array) : Array(Complex)
      return fft_helper(input, true)
    end

    def self.ifft(input : Array) : Array(Complex)
      return fft_helper(input, false).map { |e| e/input.size }
    end

    # @author James Tunnell
    # Modified stockham algorithm, output not in place
    def self.fft_helper(input : Array, forward : Bool = true) : Array(Complex)
      complex_input = input.map { |e| e.to_c }
      size = input.size
      base = Math.log2(size)
      if base.floor != base
        raise ArgumentError.new("Input size #{size} is not power of 2")
      end
      base = base.to_i
      reversed_array = DSP::Permute.radix(complex_input, 2)

      sin_mul = forward ? -1.0 : 1.0
      (1..base).each do |stride|
        m = 2**stride

        y = TWO_PI/m
        factor = Complex.new(Math.cos(y), sin_mul * Math.sin(y))

        0.step(to: size - 1, by: m) do |k|
          omega = 1
          (0...(m//2)).each do |j|
            s0 = reversed_array[k + j]
            s1 = omega * reversed_array[k + j + m//2]
            reversed_array[k + j] = s0 + s1
            reversed_array[k + j + m//2] = s0 - s1
            omega *= factor
          end
        end
      end

      return reversed_array
    end
  end
end
