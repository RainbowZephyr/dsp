module Splib

class SineOscillator
  getter :freq, :ampl, :phase, :dc, :sample_rate

  # A new instance of Oscillator. The controllable wave parameters are frequency,
  # amplitude, phase offset, and DC offset. The current phase angle is initialized
  # to the given phase offset.
  #
  # @param [Hash] args Hashed arguments. Required key is :sample_rate. Optional keys are
  #                    :wave_type, :frequency, :amplitude, :phase_offset, and :dc_offset.
  #                    See ARG_SPECS for more details.
  def initialize(@freq : Float64, @sample_rate : Float64, @ampl = 1.0, @phase = 0.0, @dc = 0.0)
    if @sample_rate <= 0.0
      raise ArgumentError.new("Sample rate #{@sample_rate} is not positive")
    end

    if @freq <= 0
      raise ArgumentError.new("Frequency #{@freq} is not positive")
    end
    @phase_incr = Float64.new((@freq * TWO_PI) / @sample_rate)
    @current_phase = @phase
  end

  # Set the frequency (also updates the rate at which phase angle increments).
  def freq=(freq : Float64)
    if freq <= 0
      raise ArgumentError.new("Frequency #{freq} is not positive")
    end
    @freq = freq
    @phase_incr = (@freq * TWO_PI) / @sample_rate
  end

  # Set the phase angle offset. Update the current phase angle according to the
  # difference between the current phase offset and the new phase offset.
  def phase=(phase : Float64)
    @current_phase += (phase - @phase);
    @phase = phase
  end

  # Produce n samples
  def samples(n : Int32)
    Array.new(n){ sample() }
  end

  # Produce one sample
  def sample()
    while(@current_phase < -Math::PI)
      @current_phase += TWO_PI
    end

    while(@current_phase > Math::PI)
      @current_phase -= TWO_PI
    end

    output = @ampl * sine(@current_phase) + @dc
    @current_phase += @phase_incr

    return output
  end

  # constant used to calculate sine wave
  K_SINE_B = 4.0 / Math::PI
  # constant used to calculate sine wave
  K_SINE_C = -4.0 / (Math::PI * Math::PI)
  # Q = 0.775
  # constant used to calculate sine wave
  K_SINE_P = 0.225

  # generate a sine wave:
  # input range: -PI to PI
  # ouput range: -1 to 1
  private def sine(x)
    y = K_SINE_B * x + K_SINE_C * x * x.abs
    # for extra precision
    y = K_SINE_P * (y * y.abs - y) + y   # Q * y + P * y * y.abs

    return y
  end
end
end
