require "../spec_helper"
require "./resampling_helper"

describe PolynomialResampling do

  test_freq = 10.0
  sample_rate = 400.0
  size = (sample_rate * 5.0 / test_freq).to_i
  signal1 = windowed_sine_signal(test_freq, sample_rate, size, Window::Blackman)

  context ".upsample" do
    it "should produce output signal with the same max frequency (put through forward FFT)" do
      [1.0, 1.5, 2.0, 2.5, 3.0].each do |upsample_factor|
        upsampled = PolynomialResampling.upsample(signal1.data, upsample_factor)

        upsampled.size.should eq(size * upsample_factor)

        signal2 = Sig.new(upsampled, sample_rate * upsample_factor)
        verify_max_freqs_are_close(signal1, signal2)
      end
    end
  end

end
