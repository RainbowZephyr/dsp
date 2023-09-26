require "../spec_helper"
require "../../src/dsp/permute/*"

describe DSP::Permute do
  it "Radix 2 permutation" do
    input = (0...16).to_a

    actual : Array(Int32) = DSP::Permute.radix(input, 2)
    expected : Array(Int32) = [0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15]

    actual.should eq(expected)
  end

  it "Radix 4 permutation" do
    input = (0...16).to_a

    actual : Array(Int32) = DSP::Permute.radix(input, 4)
    expected : Array(Int32) = [0, 4, 8, 12, 1, 5, 9, 13, 2, 6, 10, 14, 3, 7, 11, 15]

    actual.should eq(expected)
  end

  it "Radix 8 permutation" do
    input = (0...64).to_a

    actual : Array(Int32) = DSP::Permute.radix(input, 8)
    expected : Array(Int32) = [0, 8, 16, 24, 32, 40, 48, 56, 1, 9, 17, 25, 33, 41, 49, 57, 2, 10, 18, 26, 34, 42, 50, 58, 3, 11, 19, 27, 35, 43, 51, 59, 4, 12, 20, 28, 36, 44, 52, 60, 5, 13, 21, 29, 37, 45, 53, 61, 6, 14, 22, 30, 38, 46, 54, 62, 7, 15, 23, 31, 39, 47, 55, 63]

    actual.should eq(expected)
  end

  it "Radix permutation wrong base" do
    input = (0...16).to_a
    expect_raises(ArgumentError) do
      DSP::Permute.radix(input, 8)
    end
  end
  
end
