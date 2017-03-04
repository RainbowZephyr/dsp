require "../spec_helper"
require "./resampling_helper"

describe HybridResampling do

  test_freq = 10.0
  size = 128
  sample_rate = 400.0
  order = (sample_rate / test_freq).to_i
  signal1 = windowed_sine_signal(test_freq, sample_rate, size, Window::Blackman)

  describe ".resample" do
    it "should produce output signal with the same max frequency (put through forward FFT)" do
      [1.0, 1.2, 2.5, 4.1].each do |upsample_factor|
        [1,2,4].each do |downsample_factor|
          resampled = HybridResampling.resample(signal1.data, sample_rate: sample_rate,
            upsample_factor: upsample_factor, downsample_factor: downsample_factor,
            filter_order: order)

          # the actual size of the resampled data may not exactly be input.size * U / D, since the
          # upsampled input may need to be padded before downsampling
          resampled.size.should be_close(size * upsample_factor / downsample_factor, 1)

          signal2 = Sig.new(resampled, sample_rate * upsample_factor / downsample_factor)
          verify_max_freqs_are_close(signal1, signal2)
        end
      end
    end
  end
end
