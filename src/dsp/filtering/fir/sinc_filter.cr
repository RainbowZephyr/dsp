module DSP
  # Windowed sinc filter. Implements lowpass and highpass. A bandpass
  # and bandstop filter would be implemented using two of these.
  #
  # Theoretical source: http://www.labbookpages.co.uk/audio/firWindowing.html
  #
  # @author James Tunnell
  #
  class SincFilter
    getter :order, :sample_rate, :cutoff, :window_class, :lowpass_fir, :highpass_fir

    # Given a filter order, cutoff frequency, sample rate, and window class,
    # develop a FIR filter kernel that can be used for lowpass filtering.
    def initialize(order : Int32, sample_rate : Float64, cutoff : Float64, @window_class : DSP::Windows::Window.class)
      DSP.verify_even(order)
      @order = order
      size = @order + 1

      DSP.verify_positive(sample_rate)
      @sample_rate = sample_rate

      DSP.verify_positive(cutoff)
      @cutoff = cutoff

      half_sample_rate = @sample_rate / 2.0
      if @cutoff > half_sample_rate
        msg = "Cutoff freq #{cutoff} is greater than half the sample rate (#{half_sample_rate})"
        raise ArgumentError.new(msg)
      end

      transition_freq = @cutoff / @sample_rate
      b = TWO_PI * transition_freq

      # make FIR filter kernels for lowpass and highpass

      lowpass_kernel = Array.new(size, 0.0)
      highpass_kernel = Array.new(size, 0.0)
      window = @window_class.get(size)

      (0...(@order // 2)).each do |n|
        c = n - (@order // 2)
        y = Math.sin(b * c) / (Math::PI * (c))
        lowpass_kernel[size - 1 - n] = lowpass_kernel[n] = y * window[n]
        highpass_kernel[size - 1 - n] = highpass_kernel[n] = -lowpass_kernel[n]
      end
      lowpass_kernel[@order // 2] = 2 * transition_freq * window[@order // 2]
      highpass_kernel[@order // 2] = (1 - 2 * transition_freq) * window[@order // 2]

      @lowpass_fir = FirFilter.new lowpass_kernel, @sample_rate
      @highpass_fir = FirFilter.new highpass_kernel, @sample_rate
    end

    # Process the input with the lowpass FIR.
    # @return [Array] containing the filtered input.
    def lowpass(input)
      return @lowpass_fir.convolve input
    end

    # Process the input with the highpass FIR.
    # @return [Array] containing the filtered input.
    def highpass(input)
      return @highpass_fir.convolve input
    end
  end
end
