require "../spec_helper"
require "../../src/dsp/transforms/*"

describe DSP::Transforms do
  it "Radix 2 base 2" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]
    
    actual : Array(Complex) = DSP::Transforms::Radix2.fft(input)
    expected : Array(Complex) = [Complex.new(4, 0), Complex.new(1, -2.41421356237309), Complex.new(0, 0), Complex.new(1, -0.414213562373095), Complex.new(0, 0), Complex.new(1, 0.414213562373095), Complex.new(0, 0), Complex.new(1, 2.41421356237309)]
    
    actual = actual.map { |e| e.round(9) }
    expected = expected.map { |e| e.round(9) }
    
    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end
  
  it "Radix 2 non base 2" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    expect_raises(ArgumentError) do
      DSP::Transforms::Radix2.fft(input)
    end
  end
  
  it "Radix 2 base 2 random" do
    input = Array(Float64).new(64) {|e| Random.rand}
    
    actual : Array(Complex) = DSP::Transforms::Radix2.fft(input)
    expected : Array(Complex) = DSP::Transforms::DFT.fft(input)
    
    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }
    
    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end
  
  it "Radix 3 base 3" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    actual : Array(Complex) = DSP::Transforms::Radix3.fft(input)
    expected : Array(Complex) = [Complex.new(4.0, 0), Complex.new( 1.43969262, -2.49362077),
    Complex.new(-0.26604444, -0.46080249), Complex.new(  1.0, 0.0) ,
    Complex.new(0.32635182, -0.56525794), Complex.new( 0.32635182,+0.56525794),
    Complex.new(1.0        , 0        ), Complex.new(-0.26604444,+0.46080249),
    Complex.new(1.43969262,+2.49362077)]
    
    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }
    
    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end
  
  it "Radix 3 non base 3" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]
    
    expect_raises(ArgumentError) do
      DSP::Transforms::Radix3.fft(input)
    end
  end
  
  it "Radix 3 base 3 random" do
    input = Array(Float64).new(81) {|e| Random.rand}
    
    actual : Array(Complex) = DSP::Transforms::Radix3.fft(input)
    expected : Array(Complex) = dft(input)
    
    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }
    
    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end
  
  it "Radix 4 base 4" do
    input = [1.0, 1.0, 0.0, 0.0]
    
    actual : Array(Complex) = DSP::Transforms::Radix4.fft(input)
    expected : Array(Complex) = [Complex.new(2, 0), Complex.new(1, -1), Complex.new(0, 0), Complex.new(1, 1)]
    
    actual = actual.map { |e| e.round(9) }
    expected = expected.map { |e| e.round(9) }
    
    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end
  
  it "Radix 4 non base 4" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    expect_raises(ArgumentError) do
      DSP::Transforms::Radix4.fft(input)
    end
  end
  
  it "Radix 4 base 4 random" do
    input = Array(Float64).new(64) {|e| Random.rand}
    
    actual : Array(Complex) = DSP::Transforms::Radix4.fft(input)
    expected : Array(Complex) = dft(input)
    
    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }
    
    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end
  
  it "Radix 5 base 5" do
    input = [1.0, 1.0, 0.0, 0.0, 0.0]
    
    actual : Array(Complex) = DSP::Transforms::Radix5.fft(input)
    expected : Array(Complex) = 
    [Complex.new(2.0,0)        , Complex.new(1.30901699,-0.95105652),
    Complex.new(0.19098301,-0.58778525), Complex.new(0.19098301,+0.58778525),
    Complex.new(1.30901699,+0.95105652)]
    
    actual = actual.map { |e| e.round(6) }
    expected = expected.map { |e| e.round(6) }
    
    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end
  
  it "Radix 5 non base 5" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    
    expect_raises(ArgumentError) do
      DSP::Transforms::Radix5.fft(input)
    end
  end
  
  it "Radix 5 base 5 random" do
    input = Array(Float64).new(625) {|e| Random.rand}
    
    actual : Array(Complex) = DSP::Transforms::Radix5.fft(input)
    expected : Array(Complex) = dft(input)
    
    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }
    
    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end
  
  it "Radix 8 base 8" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]
    
    actual : Array(Complex) = DSP::Transforms::Radix8.fft(input)
    expected : Array(Complex) = [Complex.new(4, 0), Complex.new(1, -2.41421356237309), Complex.new(0, 0), Complex.new(1, -0.414213562373095), Complex.new(0, 0), Complex.new(1, 0.414213562373095), Complex.new(0, 0), Complex.new(1, 2.41421356237309)]
    
    actual = actual.map { |e| e.round(9) }
    expected = expected.map { |e| e.round(9) }
    
    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end
  
  
  it "Radix 8 non base 8" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0]
    
    expect_raises(ArgumentError) do
      DSP::Transforms::Radix8.fft(input)
    end
  end
  
  it "Radix 8 base 8 random" do
    input = Array(Float64).new(512) {|e| Random.rand}
    
    actual : Array(Complex) = DSP::Transforms::Radix8.fft(input)
    expected : Array(Complex) = dft(input)
    
    actual = actual.map { |e| e.round(7) }
    expected = expected.map { |e| e.round(7) }
    
    actual.should eq(expected)
    # (0...input.size).each {|e| actual[e].should be_close(expected[e], 0.000001)}
  end
  
end