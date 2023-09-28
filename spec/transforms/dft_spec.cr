require "../spec_helper"
require "../../src/dsp/transforms/*"

describe DSP::Transforms::DFT do

  # it "DFT random" do
  #   input = Array(Float64).new(127) { |e| Random.rand }

  #   actual : Array(Complex) = DSP::Transforms::Radix2.fft(input)
  #   expected : Array(Complex) = DSP::Transforms::DFT.fft(input)

  #   actual = actual.map { |e| e.round(7) }
  #   expected = expected.map { |e| e.round(7) }

  #   actual.should eq(expected)
  #   # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  # end

  it "DFT random inverse" do
    input = Array(Float64).new(513) { |e| Random.rand }

    transformed : Array(Complex) = DSP::Transforms::DFT.fft(input)
    actual : Array(Complex) = DSP::Transforms::DFT.ifft(transformed)
    expected : Array(Complex) = input.map {|e| e.to_c}

    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }

    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end
end
