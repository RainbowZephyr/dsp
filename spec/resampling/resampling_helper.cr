def verify_max_freqs_are_close(signal1, signal2)
  max_freq1 = signal1.frequency_domain.freq_magnitudes.max_by{|freq, mag| mag }[0]
  max_freq2 = signal2.frequency_domain.freq_magnitudes.max_by{|freq, mag| mag }[0]

  percent_error = (max_freq1 - max_freq2).abs / max_freq1
  percent_error.should be_close(0.0,0.25)
end
