module DSP

# Based on the "simple implementation of Biquad filters" by Tom St Denis,
# which is based on the work "Cookbook formulae for audio EQ biquad filter
# coefficients" by Robert Bristow-Johnson, pbjrbj@viconet.com  a.k.a.
# robert@audioheads.com. Available on the web at
# http://www.smartelectronix.com/musicdsp/text/filters005.txt
abstract class BiquadFilter

  # used to calculate IIR filter coefficients
  LN_2 = Math.log(2)

  @x1, @x2 = 0.0, 0.0
  @y1, @y2 = 0.0, 0.0

  # Biquad filter coefficients
  @b0, @b1, @b2 = 0.0, 0.0, 0.0
  @a0, @a1, @a2 = 0.0, 0.0, 0.0

  @b0_a0, @b1_a0, @b2_a0 = 0.0, 0.0, 0.0
  @a1_a0, @a2_a0 = 0.0, 0.0

  # filter parameters
  @critical_freq = 0.0

  getter :critical_freq, :q, :sample_rate

  def initialize(@critical_freq : Float64, @q : Float64, @sample_rate : Float64)
    DSP.verify_positive(@sample_rate)
    omega = BiquadFilter.omega(@critical_freq, @sample_rate)

    @a0, @a1, @a2, @b0, @b1, @b2 = compute_coefficients(omega)

    # # normalize coefficients by a0
    # @b0 /= @a0
    # @b1 /= @a0
    # @b2 /= @a0
    # @a1 /= @a0
    # @a2 /= @a0
    # @a0 = 1.0

    @b0_a0 = @b0 / @a0
    @b1_a0 = @b1 / @a0
    @b2_a0 = @b2 / @a0
    @a1_a0 = @a1 / @a0
    @a2_a0 = @a2 / @a0
    # @a0 = 1.0
  end

  def reset_state
    @x1 = @x2 = 0.0
    @y1 = @y2 = 0.0
  end

  def self.omega(freq, sample_rate)
    2.0 * Math::PI * freq / sample_rate
  end

  abstract def compute_coefficients(omega)

  # Calculate biquad output using Direct Form I:
  #
  # y[n] = (b0/a0)*x[n] + (b1/a0)*x[n-1] + (b2/a0)*x[n-2]
  #                     - (a1/a0)*y[n-1] - (a2/a0)*y[n-2]
  #
  # Note: coefficients are already divided by a0 when they
  # are calculated. So that step is left out during processing.
  #
  def process_sample(sample : Float64)
    # compute result
    # result = @b0 * sample + @b1 * @x1 + @b2 * @x2 -
    #     @a1 * @y1 - @a2 * @y2;
    result = @b0_a0 * sample + @b1_a0 * @x1 + @b2_a0 * @x2 - @a1_a0 * @y1 - @a2_a0 * @y2;

    # update filter state
    @x2 = @x1
    @x1 = sample

    @y2 = @y1
    @y1 = result

    return result
  end

  def process_samples(samples)
    samples.map {|sample| process_sample(sample)}
  end

  # Calculate the magnitude response for the given frequency.
  # Method for determining magnitude response is from:
  # http://dsp.stackexchange.com/questions/16885/how-do-i-manually-plot-the-frequency-response-of-a-bandpass-butterworth-filter-i/16911#16911
  def magnitude_response(freq)
    omega = BiquadFilter.omega(freq, @sample_rate)
    phi = Math.sin(omega / 2.0)**2
    b = ((@b0 + @b1 + @b2) * 0.5)**2 - phi * (4 * @b0 * @b2 * (1.0 - phi) + @b1 * (@b0 +@b2))
    a = ((@a0 + @a1 + @a2) * 0.5)**2 - phi * (4 * @a0 * @a2 * (1.0 - phi) + @a1 * (@a0 +@a2))
    return Math.sqrt(b/a)
  end

  # Calculate the magnitude response (in decibels) for the given frequency.
  def magnitude_response_db(freq)
    Gain.linear_to_db(magnitude_response(freq))
  end
end

end
