require "linalg"
require "./simple_regression"
require "./ols_multiple_linear_regression"
require "../enums/analysis/mode"

module DSP::Analysis
  class Detrend
    # This constructor initialises the prerequisites required to perform detrending. For polynomial detrending, the default polynomial @power is 2.
    # Params: signal – Signal to be detrended mode_of_op
    # Method of detrending to be used. Can be "constant", "linear", "poly".
    # def initialize(@original_signal : Array(Float64), @mode : String)
    #   if @mode == "poly"
    #     @power = 2
    #   end
    #   @trendLine = Array(Float64).new(@original_signal.size, 0.0)
    # end

    # # This constructor initialises the prerequisites required to perform detrending. For deafult detrending @mode is "linear"
    # # Params: signal – Signal to be detrended
    # def initialize(@original_signal : Array(Float64))
    #   @mode = "linear"
    #   @trendLine = Array(Float64).new(signal.size, 0.0)
    # end

    # # This constructor initialises the prerequisites required to perform detrending in polynomial @mode.
    # # Params: signal – Signal to be detrended @power – Highest polynomial @power in the trend of the signal
    # def initialize(@original_signal : Array(Float64), @power : Int32)
    #   @mode = "poly"
    #   @trendLine = Array(Float64).new(signal.size, 0.0)
    # end

    # This method detrends the signal and returns it.
    # Returns: double[] Detrended signal
    # Throws: IllegalArgumentException – if node is not linear, constant or poly
    def self.apply(signal : Array(Float64), constant? : Bool = false) : Hash(Symbol, Array(Float64))
      if !constant? 
        return linear_detrend(signal)
      else 
        return constant_detrend(signal)
      end

    end

    def self.apply(signal : Array(Float64), mode = DSP::Analysis::Mode::LINEAR, power : Int32 = 1) : Hash(Symbol, Array(Float64))
      case mode
      when DSP::Analysis::Mode::LINEAR
        return linear_detrend(signal)
      when DSP::Analysis::Mode::CONSTANT
        return constant_detrend(signal)
      when DSP::Analysis::Mode::POLYNOMIAL
        return polynomial_detrend(signal, power)
      else
        raise ArgumentError.new("Mode can only be linear, constant or poly")
      end
    end


    # This getter method to get the trend line fo the signal.
    # Returns:double[] Calculated trend line
    # def self.get_trend_line : Array(Float64)
    #     return @trendLine
    # end

    private def self.linear_detrend(signal : Array(Float64)) : Hash(Symbol, Array(Float64))
      output = Array(Float64).new(signal.size, 0.0)
      trend_line = Array(Float64).new(signal.size, 0.0)

      x = generate_x(signal)
      simple_regression = DSP::Analysis::SimpleRegression.new

      (0...signal.size).each do |i|
        simple_regression.add_data(x[i], signal[i])
      end

      slope = simple_regression.get_slope
      intercept = simple_regression.get_intercept

      (0...signal.size).each do |i|
        trend_line[i] = (x[i] * slope) + intercept
        output[i] = signal[i] - trend_line[i]
      end

      return {:detrended => output, :trend_line => trend_line}
    end

    private def self.polynomial_detrend(signal : Array(Float64), power : Int32) : Hash(Symbol, Array(Float64))
      output = Array.new(signal.size, 0.0)
      x = generate_x(signal, power)

      sr = DSP::Analysis::OLSMultipleLinearRegression.new
      sr.no_intercept = true
      sr.new_sample_data(signal, x)

      params : Array(Float64) = sr.estimate_regression_params

      trend_line = Array.new(signal.size, 0.0)

      (0...signal.size).each do |i|
        (0..power).each do |j|
          trend_line[i] += x[i][j] * params[j]
        end

        output[i] = signal[i] - trend_line[i]
      end

      return {:detrended => output, :trend_line => trend_line}
    end

    private def self.constant_detrend(signal : Array(Float64)) : Hash(Symbol, Array(Float64))
      mean = find_mean(signal)
      return {:detrended => signal.map { |i| i - mean }, :trend_line => [mean]}
    end

    @[AlwaysInline]
    def self.find_mean(arr : Array(Float64)) : Float64
      return arr.sum / arr.size
    end

    def self.generate_x(signal : Array(Float64)) : Array(Float64)
      return Array(Float64).new(signal.size) { |i| (i + 1.0) / signal.size }
    end

    private def self.generate_x(signal : Array(Float64), power : Int32) : Array(Array(Float64))
      x = Array(Array(Float64)).new(signal.size) {Array(Float64).new(power + 1, 0.0)}
      size : Float64 = signal.size.to_f
      (0...x.size).each do |i|
        (0..power).each do |j|
          if j > 1
            x[i][j] = x[i][1] ** j
          elsif j == 1
            x[i][j] = (i + 1.0) / size
          else
            x[i][j] = 1.0
          end
        end
      end

      return x
    end
  end
end
