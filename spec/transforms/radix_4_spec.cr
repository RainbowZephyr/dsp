require "../spec_helper"
require "../../src/dsp/transforms/*"

describe DSP::Transforms::Radix4 do
  it "Radix 4 power 0" do
    input = [1.0, 1.0, 0.0, 0.0]

    actual : Array(Complex) = DSP::Transforms::Radix4.fft(input)
    expected : Array(Complex) = [Complex.new(2, 0), Complex.new(1, -1), Complex.new(0, 0), Complex.new(1, 1)]

    actual = actual.map { |e| e.round(9) }
    expected = expected.map { |e| e.round(9) }

    actual.should eq(expected)
  end

  it "Radix 4 power 0 inverse" do
    input = [1.0, 1.0, 0.0, 0.0]

    transformed : Array(Complex) = DSP::Transforms::Radix4.fft(input)
    actual : Array(Complex) = DSP::Transforms::Radix4.ifft(transformed)
    expected : Array(Complex) = input.map { |e| e.to_c }

    actual = actual.map { |e| e.round(9) }
    expected = expected.map { |e| e.round(9) }

    actual.should eq(expected)
  end

  it "Radix 4 base 4" do
    input = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]

    actual : Array(Complex) = DSP::Transforms::Radix4.fft(input)
    expected : Array(Complex) = [Complex.new(8, 0), Complex.new(1, -5.02733949), Complex.new(0,0), Complex.new(1, -1.49660576), Complex.new(0, 0), Complex.new(1, -0.66817864), Complex.new(0,0), Complex.new(1, -0.19891237), Complex.new(0, 0), Complex.new(1, +0.19891237), Complex.new(0,0), Complex.new(1, 0.66817864), Complex.new(0, 0), Complex.new(1, +1.49660576), Complex.new(0,0), Complex.new(1, 5.02733949)]

    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }

    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end

  it "Radix 4 base 4 inverse" do
    input = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    input = [1.0, 1.0, 0.0, 0.0]

    transformed : Array(Complex) = DSP::Transforms::Radix4.fft(input)
    actual : Array(Complex) = DSP::Transforms::Radix4.ifft(transformed)
    expected : Array(Complex) = input.map { |e| e.to_c }

    actual = actual.map { |e| e.round(9) }
    expected = expected.map { |e| e.round(9) }

    actual.should eq(expected)
  end

  it "Radix 4 non base 4" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]

    expect_raises(ArgumentError) do
      DSP::Transforms::Radix4.fft(input)
    end
  end

  it "Radix 4 base 4 random" do
    input = Array(Float64).new(64) { |e| Random.rand }

    actual : Array(Complex) = DSP::Transforms::Radix4.fft(input)
    expected : Array(Complex) = DSP::Transforms::DFT.fft(input)

    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }

    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end

  it "Radix 4 base 4 random inverse" do
    input = Array(Float64).new(64) { |e| Random.rand }

    transformed : Array(Complex) = DSP::Transforms::Radix4.fft(input)
    actual : Array(Complex) = DSP::Transforms::Radix4.ifft(transformed)
    expected : Array(Complex) = input.map { |e| e.to_c }

    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }

    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end
end

