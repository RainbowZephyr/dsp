require "../spec_helper"
require "../../src/dsp/transforms/*"

describe DSP::Transforms::Radix2 do

  it "Radix 2 power 0" do 
    input = [1.0, 0.0]

    actual : Array(Complex) = DSP::Transforms::Radix2.fft(input)
    expected : Array(Complex) = [Complex.new(1, 0), Complex.new(1, 0)]

    actual = actual.map { |e| e.round(9) }
    expected = expected.map { |e| e.round(9) }

    actual.should eq(expected)
  end

  it "Radix 2 power 0 inverse" do 
    input = [1.0, 0.0]

    transformed : Array(Complex) = DSP::Transforms::Radix2.fft(input)
    actual : Array(Complex) = DSP::Transforms::Radix2.ifft(transformed)
    expected : Array(Complex) = input.map { |e| e.to_c }

    actual = actual.map { |e| e.round(9) }
    expected = expected.map { |e| e.round(9) }

    actual.should eq(expected)
  end

  it "Radix 2 base 2" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]

    actual : Array(Complex) = DSP::Transforms::Radix2.fft(input)
    expected : Array(Complex) = [Complex.new(4, 0), Complex.new(1, -2.41421356237309), Complex.new(0, 0), Complex.new(1, -0.414213562373095), Complex.new(0, 0), Complex.new(1, 0.414213562373095), Complex.new(0, 0), Complex.new(1, 2.41421356237309)]

    actual = actual.map { |e| e.round(9) }
    expected = expected.map { |e| e.round(9) }

    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end

  it "Radix 2 base 2 inverse" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]

    transformed : Array(Complex) = DSP::Transforms::Radix2.fft(input)
    actual : Array(Complex) = DSP::Transforms::Radix2.ifft(transformed)
    expected : Array(Complex) = [Complex.new(1, 0), Complex.new(1, 0), Complex.new(1, 0), Complex.new(1, 0.0), Complex.new(0, 0), Complex.new(0, 0.0), Complex.new(0, 0), Complex.new(0, 0)]

    actual = actual.map { |e| e.round(9) }
    expected = expected.map { |e| e.round(9) }

    actual.should eq(expected)
  end

  it "Radix 2 non base 2" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]

    expect_raises(ArgumentError) do
      DSP::Transforms::Radix2.fft(input)
    end
  end

  it "Radix 2 base 2 random" do
    input = Array(Float64).new(64) { |e| Random.rand }

    actual : Array(Complex) = DSP::Transforms::Radix2.fft(input)
    expected : Array(Complex) = DSP::Transforms::DFT.fft(input)

    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }

    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end

  it "Radix 2 base 2 random inverse" do
    input = Array(Float64).new(64) { |e| Random.rand }

    transformed : Array(Complex) = DSP::Transforms::Radix2.fft(input)
    actual : Array(Complex) = DSP::Transforms::Radix2.ifft(transformed)
    expected : Array(Complex) = input.map {|e| e.to_c}

    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }

    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end
end
