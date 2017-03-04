module Splib

# Provide resampling methods (upsampling and downsampling) using
# discrete filtering.
module DiscreteResampling

  def self.upsample(input : Array(Float64), sample_rate : Float64, upsample_factor : Int32, filter_order : Int32)
    raise ArgumentError.new("input size #{input.size} is less than four") if input.size < 4
    verify_positive(upsample_factor)
    verify_positive(sample_rate)

    output = Array(Float64).new((upsample_factor * input.size).to_i, 0.0)
    input.each_index do |i|
      output[i * upsample_factor] = input[i] * upsample_factor
    end

    filter = SincFilter.new(order: filter_order,  sample_rate: sample_rate * upsample_factor,
      cutoff: sample_rate / 2.0, window_class: Window::Nuttall)

    return filter.lowpass(output)
  end

  def self.downsample_input_padding(input_size, downsample_factor)
    npadding_needed = 0
    npast_multiple_of_downsample_factor = input_size % downsample_factor
    if npast_multiple_of_downsample_factor > 0
      npadding_needed = downsample_factor - npast_multiple_of_downsample_factor
    end

    return Array(Float64).new(npadding_needed, 0.0)
  end

  def self.downsample(input : Array(Float64), sample_rate : Float64, downsample_factor : Int32, filter_order : Int32, lowpass_cutoff : Float64)
    raise ArgumentError.new("input size #{input.size} is less than four") if input.size < 4
    verify_positive(downsample_factor)
    verify_positive(sample_rate)

    target_srate = (sample_rate.to_f / downsample_factor)
    if lowpass_cutoff > (target_srate / 2.0)
      raise ArgumentError.new("lowpass cutoff #{lowpass_cutoff} is > target sample rate / 2 #{target_srate / 2.0}")
    end

    filter = SincFilter.new(sample_rate: sample_rate, order: filter_order,
      cutoff: lowpass_cutoff, window_class: Window::Nuttall)

    input += downsample_input_padding(input.size, downsample_factor)
    filtered = filter.lowpass(input)

    output = Array(Float64).new(filtered.size / downsample_factor) do |i|
      filtered[i * downsample_factor]
    end

    return output
  end

  def self.downsample(input : Array(Float64), sample_rate : Float64, downsample_factor : Int32, filter_order : Int32)
    target_srate = sample_rate.to_f / downsample_factor
    downsample(input: input, sample_rate: sample_rate, downsample_factor: downsample_factor,
      filter_order: filter_order, lowpass_cutoff: target_srate / 2.0)
  end

  def self.resample(input : Array(Float64), sample_rate : Float64, upsample_factor : Int32, downsample_factor : Int32, filter_order : Int32)
    upsampled = upsample(input: input, sample_rate: sample_rate, upsample_factor: upsample_factor,
      filter_order: filter_order)

    upsampled_srate = sample_rate * upsample_factor
    final_srate = upsampled_srate / downsample_factor
    lowpass_cutoff = [final_srate / 2.0, sample_rate / 2.0].min
    downsampled = downsample(input: upsampled, sample_rate: upsampled_srate, downsample_factor: downsample_factor,
      filter_order: filter_order, lowpass_cutoff: lowpass_cutoff)

    return downsampled
  end
end

end
