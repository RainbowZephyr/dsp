require "../spec_helper"
require "../../src/dsp/transforms/*"

describe DSP::Transforms::Radix8 do
  it "Radix 8 power 0" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]

    actual : Array(Complex) = DSP::Transforms::Radix8.fft(input)
    expected : Array(Complex) = [Complex.new(4, 0), Complex.new(1, -2.41421356237309), Complex.new(0, 0), Complex.new(1, -0.414213562373095), Complex.new(0, 0), Complex.new(1, 0.414213562373095), Complex.new(0, 0), Complex.new(1, 2.41421356237309)]

    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }

    actual.should eq(expected)
  end

  it "Radix 8 power 0 inverse" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]

    transformed : Array(Complex) = DSP::Transforms::Radix8.fft(input)
    actual : Array(Complex) = DSP::Transforms::Radix8.ifft(transformed)
    expected : Array(Complex) = input.map { |e| e.to_c }

    actual = actual.map { |e| e.round(9) }
    expected = expected.map { |e| e.round(9) }

    actual.should eq(expected)
  end

  it "Radix 8 base 8" do
    input = [1.0] * 32 + [0.0] * 32

    actual : Array(Complex) = DSP::Transforms::Radix8.fft(input)
    expected : Array(Complex) = [Complex.new(32, +0), Complex.new(1, -20.35546762), Complex.new(0, +0),
                                 Complex.new(1, -6.74145241), Complex.new(0, +0), Complex.new(1, -3.99222378),
                                 Complex.new(0, +0), Complex.new(1, -2.79481277), Complex.new(0, +0),
                                 Complex.new(1, -2.11432236), Complex.new(0, +0), Complex.new(1, -1.66839921),
                                 Complex.new(0, +0), Complex.new(1, -1.34834391), Complex.new(0, +0),
                                 Complex.new(1, -1.10332998), Complex.new(0, +0), Complex.new(1, -0.90634717),
                                 Complex.new(0, +0), Complex.new(1, -0.74165055), Complex.new(0, +0),
                                 Complex.new(1, -0.59937693), Complex.new(0, +0), Complex.new(1, -0.47296478),
                                 Complex.new(0, +0), Complex.new(1, -0.35780572), Complex.new(0, +0),
                                 Complex.new(1, -0.25048696), Complex.new(0, +0), Complex.new(1, -0.14833599),
                                 Complex.new(0, +0), Complex.new(1, -0.04912685), Complex.new(0, +0),
                                 Complex.new(1, +0.04912685), Complex.new(0, +0), Complex.new(1, +0.14833599),
                                 Complex.new(0, +0), Complex.new(1, +0.25048696), Complex.new(0, +0),
                                 Complex.new(1, +0.35780572), Complex.new(0, +0), Complex.new(1, +0.47296478),
                                 Complex.new(0, +0), Complex.new(1, +0.59937693), Complex.new(0, +0),
                                 Complex.new(1, +0.74165055), Complex.new(0, +0), Complex.new(1, +0.90634717),
                                 Complex.new(0, +0), Complex.new(1, +1.10332998), Complex.new(0, +0),
                                 Complex.new(1, +1.34834391), Complex.new(0, +0), Complex.new(1, +1.66839921),
                                 Complex.new(0, +0), Complex.new(1, +2.11432236), Complex.new(0, +0),
                                 Complex.new(1, +2.79481277), Complex.new(0, +0), Complex.new(1, +3.99222378),
                                 Complex.new(0, +0), Complex.new(1, +6.74145241), Complex.new(0, +0),
                                 Complex.new(1, 20.35546762)]

    actual = actual.map { |e| e.round(6) }
    expected = expected.map { |e| e.round(6) }

    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end

  it "Radix 8 base 8 inverse" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]

    transformed : Array(Complex) = DSP::Transforms::Radix8.fft(input)
    actual : Array(Complex) = DSP::Transforms::Radix8.ifft(transformed)
    expected : Array(Complex) = [Complex.new(1, 0), Complex.new(1, 0), Complex.new(1, 0), Complex.new(1, 0.0), Complex.new(0, 0), Complex.new(0, 0.0), Complex.new(0, 0), Complex.new(0, 0)]

    actual = actual.map { |e| e.round(9) }
    expected = expected.map { |e| e.round(9) }

    actual.should eq(expected)
  end

  it "Radix 8 non base 8" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0]

    expect_raises(ArgumentError) do
      DSP::Transforms::Radix8.fft(input)
    end
  end

  it "Radix 8 base 8 random" do
    input = Array(Float64).new(512) { |e| Random.rand }

    actual : Array(Complex) = DSP::Transforms::Radix8.fft(input)
    expected : Array(Complex) = DSP::Transforms::DFT.fft(input)

    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }

    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end

  it "Radix 8 base 8 random inverse" do
    input = Array(Float64).new(512) { |e| Random.rand }

    transformed : Array(Complex) = DSP::Transforms::Radix8.fft(input)
    actual : Array(Complex) = DSP::Transforms::Radix8.ifft(transformed)
    expected : Array(Complex) = input.map { |e| e.to_c }

    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }

    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end
end
