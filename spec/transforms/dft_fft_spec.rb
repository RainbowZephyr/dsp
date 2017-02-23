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

describe "DFT,FFT" do
  fft_size = 128
  sample_rate = 400.0
  window = Window::BlackmanHarris.new(fft_size)

  test_freqs = [
    20.0,
    40.0,
    80.0,
    160.0
  ]

  test_freqs.each do |freq|
    osc = SineOscillator.new(freq: freq, sample_rate: sample_rate)
    input = Array.new(fft_size) do |i|
      osc.sample * window[i]
    end

    dft_output = DFT.forward input
    fft_output = FFT.forward input

    describe ".forward" do
      it "should produce a freq magnitude response peak that is within 10 percent of the test freq" do
        fft_output.size.should eq(dft_output.size)
        fft_output.each_with_index do |x,idx|
          x.should be_close(dft_output[idx], 1e-12)
        end

        percent_err = freq_percent_error(freq, dft_output, sample_rate)
        percent_err.abs.should be <= 0.1
      end
    end

    describe ".inverse" do
      it "should produce a near-identical signal to the original sent into the forward transform" do
        dft_inv = DFT.inverse(dft_output)
        fft_inv = FFT.inverse(fft_output)

        fft_inv.size.should eq(dft_inv.size)
        fft_inv.each_with_index do |x,idx|
          x.should be_close(dft_inv[idx], 1e-12)
        end

        dft_output2 = DFT.forward(dft_inv)
        percent_err = freq_percent_error(freq, dft_output2, sample_rate)
        percent_err.abs.should be <= 0.1
      end
    end
  end

end
