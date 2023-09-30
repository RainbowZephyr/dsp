require "../spec_helper"
require "../../src/dsp/transforms/*"

describe DSP::Transforms::Radix5 do
  it "Radix 5 power 0" do
    input = [1.0, 1.0, 0.0, 0.0, 1.0]

    actual : Array(Complex) = DSP::Transforms::Radix5.fft(input)
    expected : Array(Complex) = [Complex.new(3, 0),  Complex.new(1.61803399, 0), Complex.new(-0.61803399, 0), Complex.new(-0.61803399, 0), Complex.new(1.61803399, 0)]

    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }

    actual.should eq(expected)
  end

  it "Radix 5 power 0 inverse" do
    input = [1.0, 1.0, 0.0, 0.0, 1.0]

    transformed : Array(Complex) = DSP::Transforms::Radix5.fft(input)
    actual : Array(Complex) = DSP::Transforms::Radix5.ifft(transformed)
    expected : Array(Complex) = input.map { |e| e.to_c }

    actual = actual.map { |e| e.round(9) }
    expected = expected.map { |e| e.round(9) }

    actual.should eq(expected)
  end

   it "Radix 5 base 5" do
    input = [1.0, 1.0, 0.0, 0.0, 0.0]

    actual : Array(Complex) = DSP::Transforms::Radix5.fft(input)
    expected : Array(Complex) = [Complex.new(2.0, 0), Complex.new(1.30901699, -0.95105652),
                                 Complex.new(0.19098301, -0.58778525), Complex.new(0.19098301, +0.58778525),
                                 Complex.new(1.30901699, +0.95105652)]

    actual = actual.map { |e| e.round(6) }
    expected = expected.map { |e| e.round(6) }

    actual.should eq(expected)
  end

  it "Radix 5 base 5 inverse" do
    input = [1.0, 1.0, 0.0, 0.0, 0.0]

    transformed : Array(Complex) = DSP::Transforms::Radix5.fft(input)
    actual : Array(Complex) = DSP::Transforms::Radix5.ifft(transformed)
    expected : Array(Complex) = [Complex.new(1, 0), Complex.new(1, 0), Complex.new(0, 0), Complex.new(0, 0), Complex.new(0, 0)]

    actual = actual.map { |e| e.round(9) }
    expected = expected.map { |e| e.round(9) }

    actual.should eq(expected)
  end

  it "Radix 5 non base 5" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]

    expect_raises(ArgumentError) do
      DSP::Transforms::Radix5.fft(input)
    end
  end

  it "Radix 5 base 5 random" do
    input = Array(Float64).new(625) { |e| Random.rand }

    actual : Array(Complex) = DSP::Transforms::Radix5.fft(input)
    expected : Array(Complex) = DSP::Transforms::DFT.fft(input)

    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }

    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end

  it "Radix 5 base 5 random inverse" do
    input = Array(Float64).new(125) { |e| Random.rand }

    transformed : Array(Complex) = DSP::Transforms::Radix5.fft(input)
    actual : Array(Complex) = DSP::Transforms::Radix5.ifft(transformed)
    expected : Array(Complex) = input.map { |e| e.to_c }

    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }

    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end

end
