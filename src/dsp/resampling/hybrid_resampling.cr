module DSP

# Provide resampling method using polynomial upsampling and discrete filtering
# for downsampling.
module HybridResampling

  def self.resample(input : Array(Float64), sample_rate : Float64, upsample_factor : (Int32 | Float64), downsample_factor : Int32, filter_order : Int32)
    upsampled = PolynomialResampling.upsample(input: input, upsample_factor: upsample_factor)

    upsampled_srate = sample_rate * upsample_factor
    final_srate = upsampled_srate / downsample_factor
    lowpass_cutoff = [final_srate / 2.0, sample_rate / 2.0].min
    downsampled = downsample(input: upsampled, sample_rate: upsampled_srate, downsample_factor: downsample_factor,
      filter_order: filter_order, lowpass_cutoff: lowpass_cutoff)

    return downsampled
  end
end
end
