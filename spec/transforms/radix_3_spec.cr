require "../spec_helper"
require "../../src/dsp/transforms/*"

describe DSP::Transforms::Radix3 do

  it "Radix 3 power 0" do 
    input = [1.0, 0.0, 1.0]

    actual : Array(Complex) = DSP::Transforms::Radix3.fft(input)
    expected : Array(Complex) = [Complex.new(2, 0), Complex.new(0.5, 0.866025404), Complex.new(0.5, -0.866025404)]

    actual = actual.map { |e| e.round(9) }
    expected = expected.map { |e| e.round(9) }

    actual.should eq(expected)
  end

  it "Radix 3 power 0 inverse" do 
    input = [1.0, 0.0, 1.0]

    transformed : Array(Complex) = DSP::Transforms::Radix3.fft(input)
    actual : Array(Complex) = DSP::Transforms::Radix3.ifft(transformed)
    expected : Array(Complex) = input.map { |e| e.to_c }

    actual = actual.map { |e| e.round(9) }
    expected = expected.map { |e| e.round(9) }

    actual.should eq(expected)
  end

  it "Radix 3 base 3" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]

    actual : Array(Complex) = DSP::Transforms::Radix3.fft(input)
    expected : Array(Complex) = [Complex.new(4.0, 0), Complex.new(1.43969262, -2.49362077),
                                 Complex.new(-0.26604444, -0.46080249), Complex.new(1.0, 0.0),
                                 Complex.new(0.32635182, -0.56525794), Complex.new(0.32635182, +0.56525794),
                                 Complex.new(1.0, 0), Complex.new(-0.26604444, +0.46080249),
                                 Complex.new(1.43969262, +2.49362077)]

    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }

    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end

  it "Radix 3 base 3 inverse" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]

    transformed : Array(Complex) = DSP::Transforms::Radix3.fft(input)
    actual : Array(Complex) = DSP::Transforms::Radix3.ifft(transformed)
    expected : Array(Complex) = [Complex.new(1, 0), Complex.new(1, 0), Complex.new(1, 0), Complex.new(1, 0), Complex.new(0, 0), Complex.new(0, 0), Complex.new(0, 0), Complex.new(0, 0), Complex.new(0, 0)]

    actual = actual.map { |e| e.round(9) }
    expected = expected.map { |e| e.round(9) }

    actual.should eq(expected)
  end

  it "Radix 3 non base 3" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]

    expect_raises(ArgumentError) do
      DSP::Transforms::Radix3.fft(input)
    end
  end

  it "Radix 3 base 3 random" do
    input = Array(Float64).new(81) { |e| Random.rand }

    actual : Array(Complex) = DSP::Transforms::Radix3.fft(input)
    expected : Array(Complex) = DSP::Transforms::DFT.fft(input)

    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }

    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end

    it "Radix 3 base 3 random inverse" do
    input = Array(Float64).new(81) { |e| Random.rand }

    transformed : Array(Complex) = DSP::Transforms::Radix3.fft(input)
    actual : Array(Complex) = DSP::Transforms::Radix3.ifft(transformed)
    expected : Array(Complex) = input.map {|e| e.to_c}

    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }

    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end

end