require "../../spec_helper"

sample_rate = 1000.0

describe FirFilter do
  describe "#initialize" do
    context "kernel size < 2" do
      it "should raise ArgumentError" do
        expect_raises(ArgumentError) { FirFilter.new(kernel: [] of Float64, sample_rate: sample_rate) }
        expect_raises(ArgumentError) { FirFilter.new(kernel: [0.2], sample_rate: sample_rate) }
      end
    end

    context "non-positive sample rate" do
      it "should raise ArgumentError" do
        expect_raises(ArgumentError) { FirFilter.new(kernel: [0.0, 0.0], sample_rate: 0.0) }
        expect_raises(ArgumentError) { FirFilter.new(kernel: [0.0, 0.0], sample_rate: -20.0) }
      end
    end
  end

  describe "#convolve" do
    context "kernel of zeros" do
      kernel = [0.0]*4
      fir = FirFilter.new(kernel: kernel, sample_rate: sample_rate)

      context "given input of zeros" do
        it "should returns zeros" do
          fir.convolve([0.0]*kernel.size).should eq([0.0]*kernel.size)
        end
      end

      context "given input of ones" do
        it "should return zeros" do
          fir.convolve([1.0]*kernel.size).should eq([0.0]*kernel.size)
        end
      end
    end

    context "kernel of random values" do
      kernel = [1.4, 2.2, -0.3, 5.2]
      fir = FirFilter.new(kernel: kernel, sample_rate: sample_rate)

      context "given input of zeros" do
        it "should returns zeros" do
          fir.convolve([0.0]*kernel.size).should eq([0.0]*kernel.size)
        end
      end

      context "given input of single one and then zeros (unit impulse)" do
        it "should return kernel" do
          fir.convolve([1.0] + [0.0]*(kernel.size-1)).should eq(kernel)
        end
      end
    end
  end
end
