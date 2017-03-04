require "../spec_helper"

def verify_max_freqs_are_close(signal1, signal2)
  max_freq1 = signal1.frequency_domain.freq_magnitudes.max_by{|freq, mag| mag }[0]
  max_freq2 = signal2.frequency_domain.freq_magnitudes.max_by{|freq, mag| mag }[0]

  percent_error = (max_freq1 - max_freq2).abs / max_freq1
  percent_error.should be_close(0.0,0.25)
end

describe DiscreteResampling do

  test_freq = 10.0
  size = 128
  sample_rate = 400.0
  order = (sample_rate / test_freq).to_i
  signal_data = SineOscillator.new(freq: test_freq, sample_rate: sample_rate).samples(size)
  signal1 = Sig.new(signal_data, sample_rate) * Window::Blackman.new(size)
  factors = [2,4,6,12]

  describe ".upsample" do
    it "should produce output signal with the same max frequency (put through forward FFT)" do
      factors.each do |upsample_factor|
        upsampled = DiscreteResampling.upsample(signal1.data, sample_rate: sample_rate,
          upsample_factor: upsample_factor, filter_order: order)

        upsampled.size.should eq(size * upsample_factor)

        signal2 = Sig.new(upsampled, sample_rate * upsample_factor)
        verify_max_freqs_are_close(signal1, signal2)
      end
    end
  end

  describe ".downsample" do
    it "should produce output signal with the same max frequency (put through forward FFT)" do
      factors.each do |downsample_factor|
        downsampled = DiscreteResampling.downsample(signal1.data, sample_rate: sample_rate,
          downsample_factor: downsample_factor, filter_order: order)

        # the actual size of the downsampled data may not exactly be input.size / D, since the
        # input may need to be padded before downsampling
        downsampled.size.should be_close(size / downsample_factor, 1)

        signal2 = Sig.new(downsampled, sample_rate / downsample_factor)
        verify_max_freqs_are_close(signal1, signal2)
      end
    end
  end

  describe ".resample" do
    it "should produce output signal with the same max frequency (put through forward FFT)" do
      factors.each do |upsample_factor|
        factors.each do |downsample_factor|
          resampled = DiscreteResampling.resample(signal1.data, sample_rate: sample_rate,
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
