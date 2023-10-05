module DSP::Analysis
  class OLSMultipleLinearRegression
    property :no_intercept

    # Singularity @threshold for QR decomposition
    @threshold : Float32

    # Whether or not the regression model includes an intercept. True means no intercept.
    @no_intercept : Bool = false

    # Y sample data.
    @y_vector = LA::GMat.new(0, 0, Array(Float64).new)

    @x_matrix = LA::GMat.new(0, 0, Array(Float64).new)

    # Create an empty OLSMultipleLinearRegression instance.
    def initialize
      @threshold = 0
    end

    # Create an empty OLSMultipleLinearRegression instance, using the given singularity @threshold for the QR decomposition.
    # Params:
    # @threshold – the singularity @threshold
    def initialize(@threshold)
    end

    #  Loads model x and y sample data, overriding any previous sample. Computes and caches QR decomposition of the X matrix.
    # Params:
    # y – the [n,1] array representing the y sample x – the [n,k] array representing the x sample
    # Throws:
    # MathIllegalArgumentException – if the x and y array data are not compatible for the regression
    def new_sample_data(y : Array(Float64), x : Array(Array(Float64)))
      validate_sample_data(x, y)
      new_y_sample_data(y)
      new_x_sample_data(x)
    end

    # Validates sample data. Checks that
    # Neither x nor y is null or empty;
    # The size (i.e. number of rows) of x equals the size of y
    # x has at least one more row than it has columns (i.e. there is sufficient data to estimate regression coefficients for each of the columns in x plus an intercept.
    # Params:
    # x – the [n,k] array representing the x data y – the [n,1] array representing the y data
    # Throws:
    # ArgumentError – if x or y is null
    # DimensionMismatchException – if x and y do not have the same size
    # ArgumentError – if x or y are zero-size
    # MathIllegalArgumentException – if the number of rows of x is not larger than the number of columns + 1
    def validate_sample_data(x : Array(Array(Float64)), y : Array(Float64))
      if x.nil? || y.nil?
        raise ArgumentError.new("Nil inputs")
      end

      if x.size != y.size
        raise ArgumentError.new("Size mismatch")
      end

      if x.size == 0
        raise ArgumentError.new("Array can't be empty")
      end

      if x[0].size + 1 > x.size
        raise ArgumentError.new("Not enough data for number of predictors, #{x.size}, #{x[0].size}")
      end
    end

    # Loads new y sample data, overriding any previous data.
    # Params:
    # y – the array representing the y sample
    # Throws:
    # ArgumentError – if y is null
    # ArgumentError – if y is empty
    def new_y_sample_data(y : Array(Float64))
      if y.nil?
        raise ArgumentError.new("Y is nil")
      end

      if y.size == 0
        raise ArgumentError.new("Y is empty")
      end

      @y_vector = LA::GMat.new(y.size, 1, y)
    end

    # Note that there is no need to add an initial unitary column (column of 1's) when specifying a model including an intercept term.
    # This implementation computes and caches the QR decomposition of the X matrix once it is successfully loaded.
    def new_x_sample_data(x : Array(Array(Float64)))
      if x.nil?
        raise ArgumentError.new("X is nil")
      end

      if x.empty?
        raise ArgumentError.new("X is empty")
      end

      if @no_intercept
        @x_matrix = LA::GMat.new(x)
      else
        n_vars = x[0].size
        x_aug = Array(Array(Float64)).new(x.size) { Array(Float64).new(n_vars + 1, 0.0) }

        (0...x.size).each do |i|
          if x[i].size != n_vars
            raise ArgumentError.new("Dimension mismatch #{x[i].size}, #{n_vars}")
          end

          x_aug[i][0] = 1.0
          x[i].each_with_index do |value, j|
            x_aug[i][j + 1] = value
          end
        end

        @x_matrix = LA::GMat.new(x_aug)
      end
    end

    def estimate_regression_params : Array(Float64)
        # puts "X #{@x_matrix}, y #{@y_vector}"
        a, r, pvt = @x_matrix.qr
        puts "a #{a}, r #{r}, pvt #{pvt}"
      return r.solvels(@y_vector).to_a
    end
  end
end
