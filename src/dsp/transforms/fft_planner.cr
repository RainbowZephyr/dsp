require "../../misc/common_math"
require "./*"

module DSP::Transforms
  class FFTPlanner
    
    def self.fft(input : Array) : Array(Complex)
      return fft_helper(input, true)
    end
    
    def self.ifft(input : Array) : Array(Complex)
      return fft_helper(input, false).map{|e| e/input.size}
    end
    
    def self.fft_helper(input : Array, forward? : Bool) : Array(Complex)
      size = input.size
      exponents = CommonMath.exponents(size)
      
      classes = {
      8 => -> {DSP::Transforms::Radix8.fft_helper(input, forward?)},
      # 5 => -> {DSP::Transforms::Radix5.fft_helper(input, forward?)},
      4 => -> {DSP::Transforms::Radix4.fft_helper(input, forward?)},
      # 3 => -> {DSP::Transforms::Radix3.fft_helper(input, forward?)},
      2 => -> {DSP::Transforms::Radix2.fft_helper(input, forward?)},
      0 => -> {DSP::Transforms::DFT.fft_helper(input, forward?)}
    }
    
    result = classes[exponents[0]].call
    return result
  end
  
end
end