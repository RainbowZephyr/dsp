module DSP
  # Extended windowed sinc filter. Implements bandpass and bandstop using
  # two sinc filters
  #
  # Theoretical source: http://www.labbookpages.co.uk/audio/firWindowing.html
  #
  # @author James Tunnell
  #
  class DualSincFilter
    getter :order, :sample_rate, :left_cutoff, :right_cutoff, :window_class, :left_filter, :right_filter, :bandpass_fir, :bandstop_fir

    # Given a filter order, 2 cutoff frequencies, sample rate, and window class,
    # develop a FIR filter kernel that can be used for lowpass filtering.
    def initialize(order : Int32, sample_rate : Float64, left_cutoff : Float64, right_cutoff : Float64, @window_class : DSP::Windows::Window.class)
      if left_cutoff >= right_cutoff
        msg = "Left cutoff freq #{left_cutoff} is not less than right cutoff freq #{right_cutoff}"
        raise ArgumentError.new(msg)
      end

      verify_positive(sample_rate)
      @sample_rate = sample_rate

      verify_even(order)
      @order = order
      size = @order + 1

      @left_filter = SincFilter.new(order: order, cutoff: left_cutoff, sample_rate: sample_rate, window_class: window_class)
      @right_filter = SincFilter.new(order: order, cutoff: right_cutoff, sample_rate: sample_rate, window_class: window_class)

      # make FIR filter kernels for bandpass and bandstop
      bandpass_kernel = Array.new(size, 0.0)
      bandstop_kernel = Array.new(size, 0.0)
      window = @window_class.get(size)

      (0...(@order / 2)).each do |n|
        bandpass_kernel[size - 1 - n] = bandpass_kernel[n] = @right_filter.lowpass_fir.kernel[n] + @left_filter.highpass_fir.kernel[n]
        bandstop_kernel[size - 1 - n] = bandstop_kernel[n] = @left_filter.lowpass_fir.kernel[n] + @right_filter.highpass_fir.kernel[n]
      end

      left_transition_freq = left_cutoff.to_f / @sample_rate
      right_transition_freq = right_cutoff.to_f / @sample_rate
      bw_times_two = 2.0 * (right_transition_freq - left_transition_freq)
      window_center_val = window[@order // 2]

      bandpass_kernel[@order // 2] = bw_times_two * window_center_val
      bandstop_kernel[@order // 2] = (1.0 - bw_times_two) * window_center_val

      @bandpass_fir = FirFilter.new bandpass_kernel, @sample_rate
      @bandstop_fir = FirFilter.new bandstop_kernel, @sample_rate
    end

    # Process the input with the bandpass FIR.
    # @return [Array] containing the filtered input.
    def bandpass(input)
      return @bandpass_fir.convolve input
    end

    # Process the input with the bandstop FIR.
    # @return [Array] containing the filtered input.
    def bandstop(input)
      return @bandstop_fir.convolve input
    end
  end
end
