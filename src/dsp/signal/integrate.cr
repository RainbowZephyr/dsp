module DSP::Signal
  class Integrate

    # Digital numerical integration of signal
    # This will require detrend later
    def self.apply(waveform : Array(Float64), sample_rate : Float64, linear_factor : Float64 = 1.0) : Array(Float64)
      result = Array(Float64).new(waveform.size, 0.0)
      tmp = waveform.clone

      if linear_factor != 1.0
        tmp.map! { |e| e * linear_factor }
      end

      (1...result.size).each { |i|
        result[i] = (tmp[i] + tmp[i - 1]) / 2 * (1.0 / sample_rate) + result[i - 1]
      }

      return result
    end
  end
end
