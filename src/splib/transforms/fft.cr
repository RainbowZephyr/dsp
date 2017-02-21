require "complex"

module Splib

# Perform FFT transforms, forward and inverse.
# @author James Tunnell
class FFT

  # Convert real input array to complex input array and pass along to that overload
  def self.forward(input : Array(Float64))
    FFT.forward(input.map {|f| Complex.new(f,0.0) })
  end

  # Forward Radix-2 FFT transform using decimation-in-time. Operates on an array of complex values
  # that represent a time domain signal. Based on the in-place algorithm described in:
  # https://en.wikipedia.org/wiki/Cooley%E2%80%93Tukey_FFT_algorithm#Data_reordering.2C_bit_reversal.2C_and_in-place_algorithms
  # @param input An array of complex values. If size is not an exact power-of-two, it will be
  #   padded with zeros.
  def self.forward(input : Array(Complex))
    npadding = Math.pw2ceil(input.size) - input.size
    if npadding > 0
      input += Array.new(npadding){ Complex.new(0.0,0.0) }
    end
    n = input.size

    power_of_two = Math.log2(n).to_i
    x = bit_reverse_order(input, power_of_two)

    (1..power_of_two).each do |s|
      m = 2**s
      y = TWO_PI/m
      wm = Complex.new(Math.cos(y), -Math.sin(y))

      0.step(to: n-1, by: m) do |k|

        w = 1
        (0...(m/2)).each do |j|
          t = w * x[k + j + m/2]
          u = x[k + j]
          x[k + j] = u + t
          x[k + j + m/2] = u - t
          w *= wm
        end
      end
    end
    return x
  end

  # Inverse Radix-2 FFT transform. Leverages the forward FFT, but scales the result by input size.
  def self.inverse(input : Array(Complex))
    n = input.size
    power_of_two = Math.log2(n)
    if power_of_two.floor != power_of_two
      raise ArgumentError.new("input size #{n} is not power of 2")
    end

    x = FFT.forward(input)
    return x.map {|val| val / n }
  end

  private def self.get_bit_reversed_addr(i, nbits)
    i.to_s(2).rjust(nbits, '0').reverse.to_i(2)
  end

  private def self.bit_reverse_order(input, m)
    Array.new(input.size){|i| input[get_bit_reversed_addr(i, m)] }
  end
end

end
