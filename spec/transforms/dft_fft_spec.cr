# require "../spec_helper"

# def is_biggest_bin_also_closest?(tgt_freq, fft_output, sample_rate)
#   half_fft_output = fft_output[0...(fft_output.size / 2)]

#   magnitudes = half_fft_output.map {|x| x.abs}
#   biggest_bin = magnitudes.index(magnitudes.max)

#   freq_diffs = (0...(fft_output.size / 2)).map do |idx|
#     f = (sample_rate * idx) / fft_output.size
#     (f - tgt_freq).abs
#   end
#   closest_bin = freq_diffs.index(freq_diffs.min)

#   return closest_bin == biggest_bin
# end

# describe "DFT,FFT" do
#   fft_size = 128
#   sample_rate = 400.0
#   window = DSP::Windows::BlackmanHarris.new(fft_size)

#   test_freqs = [
#     20.0,
#     40.0,
#     80.0,
#     160.0
#   ]

#   test_freqs.each do |freq|
#     osc = SineOscillator.new(freq: freq, sample_rate: sample_rate)
#     input = Array.new(fft_size) do |i|
#       osc.sample * window[i]
#     end

#     dft_output = DFT.forward input
#     fft_output = FFT.forward input

#     describe ".forward" do
#       it "should produce a freq magnitude response peak that is within 10 percent of the test freq" do
#         fft_output.size.should eq(dft_output.size)
#         fft_output.each_with_index do |x,idx|
#           x.should be_close(dft_output[idx], 1e-12)
#         end

#         is_biggest_bin_also_closest?(freq, dft_output, sample_rate).should be_truthy
#       end
#     end

#     describe ".inverse" do
#       it "should produce a near-identical signal to the original sent into the forward transform" do
#         dft_inv = DFT.inverse(dft_output)
#         fft_inv = FFT.inverse(fft_output)

#         fft_inv.size.should eq(dft_inv.size)
#         fft_inv.each_with_index do |x,idx|
#           x.should be_close(dft_inv[idx], 1e-12)
#         end

#         dft_output2 = DFT.forward(dft_inv)
#         is_biggest_bin_also_closest?(freq, dft_output2, sample_rate).should be_truthy
#       end
#     end
#   end

# end
