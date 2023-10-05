module DSP
    class OLSMultipleLinearRegression
        # Cached QR decomposition of X matrix
        qr : DSP::QRDecomposition? = nil
        
        # Singularity @threshold for QR decomposition
        @threshold : Float32

        # Whether or not the regression model includes an intercept. True means no intercept.
        @noIntercept : Bool = false
        
        # Y sample data.
        @yVector = LibGSL::Vector::Real.new

        # Create an empty OLSMultipleLinearRegression instance.
        def initialize
            self.new(0.0)
        end
        
        # Create an empty OLSMultipleLinearRegression instance, using the given singularity @threshold for the QR decomposition.
        # Params:
        # @threshold – the singularity @threshold
        def initialize(threshold : Float64)
            @threshold = threshold
        end
        
        # Params: noIntercept – true means the model is to be estimated without an intercept term
        def self.set_no_intercept(noIntercept : Bool)
            @@noIntercept = noIntercept
        end
        
        #  Loads model x and y sample data, overriding any previous sample. Computes and caches QR decomposition of the X matrix.
        # Params:
        # y – the [n,1] array representing the y sample x – the [n,k] array representing the x sample
        # Throws:
        # MathIllegalArgumentException – if the x and y array data are not compatible for the regression
        def new_sample_data(y : Array(Float64), x : Array(Array(Float64)))
            DSP::OLSMultipleLinearRegression.validate_sample_data(x, y)
            DSP::OLSMultipleLinearRegression.new_y_sample_data(y)
            DSP::OLSMultipleLinearRegression.new_x_sample_data(x)
        end
        
        # Validates sample data. Checks that
        # Neither x nor y is null or empty;
        # The size (i.e. number of rows) of x equals the size of y
        # x has at least one more row than it has columns (i.e. there is sufficient data to estimate regression coefficients for each of the columns in x plus an intercept.
        # Params:
        # x – the [n,k] array representing the x data y – the [n,1] array representing the y data
        # Throws:
        # NullArgumentException – if x or y is null
        # DimensionMismatchException – if x and y do not have the same size
        # NoDataException – if x or y are zero-size
        # MathIllegalArgumentException – if the number of rows of x is not larger than the number of columns + 1
        def self.validate_sample_data(x : Array(Array(Float64)), y : Array(Float64))
            if x.nil? || y.nil?
                raise NullArgumentException.new
            end
            if x.size != y.size
                raise DimensionMismatchException.new(y.size, x.size)
            end
            if x.size == 0
                raise NoDataException.new
            end
            if x[0].size + 1 > x.size
                raise MathIllegalArgumentException.new(
                LocalizedFormats::NOT_ENOUGH_DATA_FOR_NUMBER_OF_PREDICTORS,
                x.size, x[0].size)
            end
        end
        
        
        # Loads new y sample data, overriding any previous data.
        # Params:
        # y – the array representing the y sample
        # Throws:
        # NullArgumentException – if y is null
        # NoDataException – if y is empty
        def self.newYSampleData(y : Array(Float64))
            if y.nil?
                raise NullArgumentException.new
            end
            if y.size == 0
                raise NoDataException.new
            end
            @yVector = y.to_vector
        end
        
        # Note that there is no need to add an initial unitary column (column of 1's) when specifying a model including an intercept term.
        # This implementation computes and caches the QR decomposition of the X matrix once it is successfully loaded.
        def self.newXSampleData(x : Array(Array(Float64)))
            super.newXSampleData(x)
            qr = QRDecomposition.new(getX(), @threshold)
        end
    end
end
