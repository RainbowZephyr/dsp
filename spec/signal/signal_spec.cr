require "../spec_helper"

sample_rate = 40.0
sample_period = 1.0 / sample_rate

describe Signal do
  describe "#size" do
    it "should be equal to signal data size" do
      [0,1,5,27].each do |nsamples|
        Sig.new([0.0]*nsamples, sample_rate).size.should eq(nsamples)
      end
    end
  end

  describe "#==" do
    context "different sample rate" do
      it "should return false" do
        s1 = Sig.new([1.0]*5, 100.0)
        s2 = Sig.new([1.0]*5, 101.0)
        s1.should_not eq(s2)
      end
    end

    context "different signal data" do
      it "should return false" do
        s1 = Sig.new([1.0]*5, 100.0)
        s2 = Sig.new([1.0]*6, 100.0)
        s1.should_not eq(s2)
      end
    end

    context "sample rate and signal data the same" do
      it "should return true" do
        s1 = Sig.new([1.0, 4.2, -2.2], 100.0)
        s2 = Sig.new([1.0, 4.2, -2.2], 100.0)
        s1.should eq(s2)
      end
    end
  end

  describe "#clone" do
    it "should return a new, identical object" do
      s1 = Sig.new([1.0,3.0,5.0], sample_rate)
      s2 = s1.clone
      s1.should_not be(s2)
      s1.should eq(s2)
    end
  end

  describe "#duration" do
    it "should use size * sample period" do
      [0,1,5,27].each do |nsamples|
        Sig.new([0.0]*nsamples, sample_rate).duration.should eq(nsamples * sample_period)
      end
    end
  end

  describe "#max_magnitude" do
    it "should return largest magnitude of all the signal data" do
      {
        [-1.0,0.0,0.5] => 1.0,
        [0.2, 1.5, 0.8 ] => 1.5
      }.each do |samples, expected_max_magnitude|
        Sig.new(samples, sample_rate).max_magnitude.should eq(expected_max_magnitude)
      end
    end
  end

  describe "#abs" do
    it "should produce a new signal with abs applied to data" do
      s = Sig.new([1.0, 2.0, -1.0], sample_rate)
      s2 = Sig.new([1.0, 2.0, 1.0], sample_rate)
      s.abs.should eq(s2)
    end
  end

  describe "#normalize" do
    s1 = Sig.new([0.125, -0.25, 0.5], sample_rate)

    context "given max magnitude equal to current max magnitude" do
      it "should produce a new, identical signal" do
        s1.normalize(s1.max_magnitude).should eq(s1)
      end
    end

    context "given no max magnitude" do
      it "should produce a new signal normalized to max magnitude 1.0 by default" do
        s2 = Sig.new([0.25, -0.5, 1.0], sample_rate)
        s1.normalize.should eq(s2)
      end
    end

    context "given max magnitude different than current" do
      it "should produce a new signal with max magnitude equal to given" do
        s2 = Sig.new([0.0625, -0.125, 0.25], sample_rate)
        s1.normalize(0.25).should eq(s2)

        s3 = Sig.new([0.5, -1.0, 2.0], sample_rate)
        s1.normalize(2.0).should eq(s3)
      end
    end
  end
end
