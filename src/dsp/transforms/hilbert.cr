require "./fft_planner"

module DSP::Transforms
  class Hilbert
    def self.transform(x : Array) : Array(Complex)
      fft_transformed = DSP::Transforms::FFTPlanner.fft(x)
      convolution = Array(Float64).new(x.size, 0.0)

      convolution[0] = 1.0
      if x.size % 2 == 0
        (1...(x.size/2)).each { |i| convolution[i] = 2.0 }
        convolution[x.size // 2] = 1.0
      else
        (1...((x.size + 1)/2)).each { |i| convolution[i] = 2.0 }
      end

      (0...x.size).each { |i|
        fft_transformed[i] *= convolution[i]
      }

      # Analytic signal, real + imag, where imag is the hilbert transformed data
      reconstructed = DSP::Transforms::FFTPlanner.ifft(fft_transformed)
      return reconstructed
    end
  end
end
