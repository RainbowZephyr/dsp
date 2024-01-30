module DSP
  # General FIR filter class. Contains the filter kernel and performs convolution.
  class FirFilter
    getter :kernel, :order, :sample_rate

    # A new instance of FIR. Filter order will by kernel size - 1.
    # @param [Array] kernel Filter kernel values.
    # @param [Numeric] sample_rate The sample rate the filter operates at.
    def initialize(kernel : Array(Float64), sample_rate : Float64)
      if kernel.size < 2
        raise ArgumentError.new("Kernel size #{kernel.size} must be at least 2")
      end

      @kernel = kernel
      @kernel_size = kernel.size.as(Int32)
      @order = (@kernel_size - 1).as(Int32)

      verify_positive(sample_rate)
      @sample_rate = sample_rate
    end

    # Convolve the given input data with the filter kernel.
    # @param [Array] input Array of input data to by convolved with filter kernel.
    #                      The array size must be greater than the filter kernel size.
    def convolve(input)
      if input.size < @kernel_size
        msg = "input.size #{input.size} is less than filter kernel size #{@kernel_size}"
        raise ArgumentError.new(msg)
      end

      Array.new(input.size) do |n|
        sum = 0.0
        imax = [n, @order].min
        (0..imax).each do |i|
          sum += @kernel[i] * input[n - i]
        end
        sum
      end
    end

    def freq_response
      _freq_response(false)
    end

    def freq_response_db
      _freq_response(true)
    end

    # Calculate the filter frequency magnitude response.
    # @param [Numeric] use_db Calculate magnitude in dB.
    private def _freq_response(use_db)
      input = [0.0] + @kernel # make the size even
      output = DSP::Transforms::FFTPlanner.fft(input)

      output = output[0...(output.size // 2)] # ignore second half (mirror image)
      output = output.map { |x| x.abs }       # calculate magnitudes from complex values

      if use_db
        output = output.map { |x| Gain.linear_to_db x }
      end

      response = {} of Float64 => Float64
      output.each_index do |n|
        frequency = (@sample_rate * n) / (output.size * 2.0)
        response[frequency] = output[n]
      end

      return response
    end

    # def plot_freq_response
    #   _plot_freq_response_db(false)
    # end
    #
    # def plot_freq_response_db
    #   _plot_freq_response_db(true)
    # end
    #
    # # Calculate the filter frequency magnitude response and
    # # graph the results.
    # # @param [Numeric] use_db Calculate magnitude in dB.
    # def _plot_freq_response_db(use_db)
    #   # plotter = Plotter.new(
    #   #   :title => "Freq magnitude response of #{@order}-order FIR filter",
    #   #   :xlabel => "frequency (Hz)",
    #   #   :ylabel => "magnitude#{use_db ? " (dB)" : ""}",
    #   #   :logscale => "x"
    #   # )
    #   #
    #   # plotter.plot_2d "" => freq_response(use_db)
    #   File.open("tmp.dat", "wb") do |f|
    #     _freq_response(use_db).each do |freq, magn|
    #       f.puts("#{freq}\t#{magn}")
    #     end
    #   end
    #   `graph tmp.dat --output-format X`
    # end
  end
end
