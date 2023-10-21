require "../spec_helper"

describe DSP::Signal::Differentiate do
  it "Short Signal" do
    waveform = [1.0, 2.0, 3.0, 4.0]
    sample_rate = 5.0 
    factor = 9.80665

    actual = DSP::Signal::Differentiate.apply(waveform, sample_rate, factor)
    expected = [0.0, 49.033249999999995, 49.03325000000001, 49.03324999999999]
    actual.should eq(expected)
  end
end
