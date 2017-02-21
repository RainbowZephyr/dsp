require "../spec_helper"

def freq_percent_error(tgt_freq, fft_output, sample_rate)
  first_half_fft_magnitudes = fft_output[0...(fft_output.size / 2)].map { |x| x.abs }

  magn_response = {} of Float64 => Float64
  first_half_fft_magnitudes.each_index do |n|
    f = (sample_rate * n) / fft_output.size
    magn_response[f] = first_half_fft_magnitudes[n]
  end

  max_freq = magn_response.max_by {|f,magn| magn }[0]
  return (max_freq - tgt_freq).abs / tgt_freq
end

describe FFT do
  fft_size = 128
  sample_rate = 400.0

  test_freqs = [
    20.0,
    40.0,
    80.0,
    160.0
  ]

  describe ".forward" do
    it "should produce a freq magnitude response peak that is within 10 percent of the test freq" do
      test_freqs.each do |freq|
        osc = SineOscillator.new(freq: freq, sample_rate: sample_rate)
        window = Window::BlackmanHarris.new(fft_size)
        input = Array.new(fft_size) do |i|
          osc.sample * window[i]
        end

        output = FFT.forward input
        percent_err = freq_percent_error(freq, output, sample_rate)
        percent_err.abs.should be <= 0.1
      end
    end
  end

  context ".inverse" do
    it "should produce a near-identical signal to the original sent into the forward FFT" do
      [test_freqs[-1]].each do |freq|
        osc = SineOscillator.new(freq: freq, sample_rate: sample_rate)
        window = Window::BlackmanHarris.new(fft_size)
        input = Array.new(fft_size) do |i|
          osc.sample * window[i]
        end

        output = FFT.forward(FFT.inverse(FFT.forward(input)))
        percent_err = freq_percent_error(freq, output, sample_rate)
        percent_err.abs.should be <= 0.1
      end
    end
  end

end
