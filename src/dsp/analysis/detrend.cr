module DSP
    class Detrend
        @mode : String
        @power : Int32
        @originalSignal : Array(Float64)
        @detrendedSignal : Array(Float64)
        @trendLine : Array(Float64)
        
        # This constructor initialises the prerequisites required to perform detrending. For polynomial detrending, the default polynomial @power is 2.
        # Params: signal – Signal to be detrended mode_of_op
        # Method of detrending to be used. Can be "constant", "linear", "poly".
        def initialize(signal : Array(Float64), mode_of_op : String)
            @originalSignal = signal
            @mode = mode_of_op
            if @mode == "poly"
                @power = 2
            end
            @trendLine = Array(Float64).new(signal.size, 0.0)
        end
        
        # This constructor initialises the prerequisites required to perform detrending. For deafult detrending @mode is "linear"
        # Params: signal – Signal to be detrended
        def initialize(signal : Array(Float64))
            @originalSignal = signal
            @mode = "linear"
            @trendLine = Array(Float64).new(signal.size, 0.0)
        end
        
        # This constructor initialises the prerequisites required to perform detrending in polynomial @mode.
        # Params: signal – Signal to be detrended @power – Highest polynomial @power in the trend of the signal
        def initialize(signal : Array(Float64), @power : Int32)
            @originalSignal = signal
            @mode = "poly"
            @trendLine = Array(Float64).new(signal.size, 0.0)
        end
        
        # This method detrends the signal and returns it.
        # Returns: double[] Detrended signal
        # Throws: IllegalArgumentException – if node is not linear, constant or poly
        def self.detrendSignal : Array(Float64)
            if @mode == "constant"
                @detrendedSignal = constantDetrend(@originalSignal)
                return @detrendedSignal
            elsif @mode == "poly"
                @detrendedSignal = polyDetrend(@originalSignal, @power)
                return @detrendedSignal
            elsif @mode == "linear"
                @detrendedSignal = linearDetrend(@originalSignal)
                return @detrendedSignal
            else
                raise ArgumentError.new("@mode can only be linear, constant or poly.")
            end
        end
        
        # This getter method to get the trend line fo the signal.
        # Returns:double[] Calculated trend line
        def self.get_trend_line : Array(Float64)
            return @trendLine
        end
        
        def self.linearDetrend(y : Array(Float64)) : Array(Float64)
            output = Array(Float64).new(y.size, 0.0)
            x = generateX(y)
            sr = DSP::SimpleRegression.new
            (0...y.size).each do |i|
                sr.addData(x[i], y[i])
            end
            slope = sr.getSlope
            intercept = sr.getIntercept
            (0...y.size).each do |i|
                @trendLine[i] = (x[i] * slope) + intercept
                output[i] = y[i] - @trendLine[i]
            end
            return output
        end
        
        def self.polyDetrend(y : Array(Float64), @power : Int32) : Array(Float64)
            output = Array.new(y.size, 0.0)
            x = generateX(y, @power)
            sr = Statsample::Regression::Multiple.new(x, y)
            sr.no_intercept = true
            params = sr.coefficients
            @trendLine = Array.new(y.size, 0.0)
            (0...y.size).each do |i| 
                (0..@power).each do |j| 
                    @trendLine[i] += x[i][j] * params[j]
                end
                
                output[i] = y[i] - @trendLine[i]
            end
            
            return output
        end
        
        def self.constant_detrend(y : Array(Float64)) : Array(Float64)
            output = Array(Float64).new(y.size, 0.0)
            mean = find_mean(y)
            y.each_with_index do |val, i|
                output[i] = val - mean
            end
            return output
        end
        
        def self.find_mean(arr : Array(Float64)) : Float64
            return arr.sum / arr.size
        end
        
        def self.generateX(y : Array(Float64)) : Array(Float64)
            x = Array(Float64).new(y.size, 0.0)
            len_y = y.size
            (0...x.size).each do |i|
                x[i] = (i + 1) / len_y
            end
            return x
        end
        
        private def self.generateX(y : Array(Float64), @power : Int32) : Array(Array(Float64))
            x = Array(Array(Float64)).new(y.size, Array(Float64).new(@power + 1, 0.0))
            len_y = y.size.to_f64
            (0...x.size).each do |i|
                (0..@power).each do |j|
                    if j > 1
                        x[i][j] = x[i][1].pow(j)
                    elsif j == 1
                        x[i][j] = (i + 1).to_f64 / len_y
                    else
                        x[i][j] = 1.0
                    end
                    return x
                end
            end
        end
    end
end