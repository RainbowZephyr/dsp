module DSP

# Frequency domain analysis class. On instantiation a forward FFT is performed
# on the given time series data, and the results are stored in full and half form.
# The half-FFT form cuts out the latter half of the FFT results. Also, for the
# half-FFT the complex values will be converted to magnitude (linear or decibel)
# if specified in :fft_format (see FFT_FORMATS for valid values).
class FrequencyDomain
  def initialize(@data : Array(Float64), @sample_rate : Float64)
    verify_positive(@sample_rate)

    @fft_full = uninitialized Array(Complex)
    @fft_half = uninitialized Array(Complex)

    @fft_full = DSP::Transforms::FFTPlanner.fft(@data)
    @fft_half = @fft_full[0...(@fft_full.size // 2)]
  end

  def freq_magnitudes
    freq_magn = {} of Float64 => Float64

    @fft_half.each_index do |i|
      freq_magn[idx_to_freq(i)] = @fft_half[i].abs
    end

    return freq_magn
  end

  def freq_magnitudes_db
    freq_magn_db = {} of Float64 => Float64

    @fft_half.each_index do |i|
      freq_magn_db[idx_to_freq(i)] = Gain.linear_to_db(@fft_half[i].abs)
    end

    return freq_magn_db
  end

  # Convert an FFT output index to the corresponding frequency bin
  def idx_to_freq(idx)
    return (idx * @sample_rate.to_f) / @fft_full.size
  end

  # Convert an FFT frequency bin to the corresponding FFT output index
  def freq_to_idx(freq)
    return (freq * @fft_full.size) / @sample_rate.to_f
  end

  # Find frequency peak values.
  def peaks
    # map positive maxima to indices
    fft_extrema = Extrema(Float64).new(@fft_half)

    freq_peaks = {} of Float64 => Float64
    fft_extrema.positive_maxima.keys.sort.each do |idx|
      freq = idx_to_freq(idx)
      freq_peaks[freq] = @fft_half[idx]
    end

    return freq_peaks
  end

  # Find frequency peak values.
  def peaks_db
    # map positive maxima to indices
    fft_extrema = Extrema(Float64).new(@fft_half)

    freq_peaks = {} of Float64 => Float64
    fft_extrema.positive_maxima.keys.sort.each do |idx|
      freq = idx_to_freq(idx)
      freq_peaks[freq] = Gain.linear_to_db(@fft_half[idx])
    end

    return freq_peaks
  end
end

end
