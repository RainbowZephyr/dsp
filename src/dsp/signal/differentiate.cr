module DSP::Signal
  class Differentiate

    # Digital numerical differentiation of signal
    # This will require detrend later
    def self.apply(waveform : Array(Float64), sample_rate : Float64, linear_factor : Float64 = 1.0) : Array(Float64)
      result = Array(Float64).new(waveform.size, 0.0)
      tmp = waveform.clone

      if linear_factor != 1.0
        tmp.map! { |e| e * linear_factor }
      end

      (1...waveform.size).each { |i|
        result[i] = (tmp[i] - tmp[i - 1]) * sample_rate
      }

      return result

    end
  end
end
