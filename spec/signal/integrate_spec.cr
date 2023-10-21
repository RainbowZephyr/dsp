require "../spec_helper"

describe DSP::Signal::Integrate do
  it "Short Signal" do
    waveform = [1.0, 2.0, 3.0, 4.0]
    sample_rate = 800.0 
    factor = 9.80665

    actual = DSP::Signal::Integrate.apply(waveform, sample_rate, factor)
    expected = [0.0, 0.01838746875, 0.04903325, 0.09193734375]
    actual.should eq(expected)
  end
end
