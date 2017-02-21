require "../spec_helper"

describe SineOscillator do
  sample_rate = 4000.0
  sample_period = 1.0 / sample_rate

  describe "#samples" do
    it "should be very close to outputs from Math.sin" do
      [ 20.0, 200.0, 400.0 ].each do |freq|
        [1.0, 0.5, -3.3].each do |ampl|
          osc = SineOscillator.new(ampl: ampl, freq: freq, sample_rate: sample_rate)
          osc_period = 1.0 / freq
          samples_per_period = (osc_period / sample_period).to_i

          osc.samples(samples_per_period).each_with_index do |actual_sample, idx|
            phase = (TWO_PI * idx) / samples_per_period
            expected_sample = ampl * Math.sin(phase)

            actual_sample.should be_close(expected_sample, 1e-2)
          end
        end
      end
    end
  end

end
