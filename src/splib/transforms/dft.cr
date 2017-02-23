require "complex"

module Splib

# Perform DFT transforms, forward and inverse.
# @author James Tunnell
class DFT
  def self.forward(input : Array(Float64))
    DFT.forward(input.map {|x| Complex.new(x,0.0)})
  end

  def self.forward(input : Array(Complex))
    input_size = input.size
    verify_even(input_size)

    Array.new(input_size) do |n|
      sum = Complex.new(0.0,0.0)
      a = -TWO_PI * n / input_size
      input.each_index do |k|
        b = a * k
        sum += input[k] * Complex.new(Math.cos(b), Math.sin(b))
      end
      sum
    end
  end

  def self.inverse(input : Array(Complex))
    input_size = input.size
    verify_even(input_size)

    Array.new(input_size) do |n|
      sum = Complex.new(0.0,0.0)
      a = TWO_PI * n / input_size
      input.each_index do |k|
        b = a * k
        sum += input[k] * Complex.new(Math.cos(b), Math.sin(b))
      end
      sum / input.size
    end
  end
end

end
