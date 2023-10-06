module DSP::Analysis
    # Implemented from commons.math3 in Java

    # Estimates an ordinary least squares regression model with one independent variable.
    # y = intercept + slope * x
    # Standard errors for intercept and slope are available as well as ANOVA, r-square and Pearson's r statistics.
    # Observations (x,y pairs) can be added to the model one at a time or they can be provided in a 2-dimensional array. The observations are not stored in memory, so there is no limit to the number of observations that can be added to the model.
    # Usage Notes:
    # When there are fewer than two observations in the model, or when there is no variation in the x values (i.e. all x values are the same) all statistics return NaN. At least two observations with different x coordinates are required to estimate a bivariate regression model.
    # Getters for the statistics always compute values based on the current set of observations -- i.e., you can get statistics, then add more data and get updated statistics without using a new instance. There is no "compute" method that updates all statistics. Each of the getters performs the necessary computations to return the requested statistic.
    # The intercept term may be suppressed by passing false to the SimpleRegression(boolean) constructor. When the hasIntercept property is false, the model is estimated without a constant term and getIntercept() returns 0.
    class SimpleRegression
        
        # Serializable version identifier
        SERIALVERSIONUID = -3004689053607543335
        
        # sum of x values
        @sum_x : Float64 = 0.0
        
        # total variation in x (sum of squared deviations from xbar)
        @sum_xx : Float64 = 0.0
        
        # sum of y values
        @sum_y : Float64 = 0.0
        
        # total variation in y (sum of squared deviations from ybar)
        @sum_yy : Float64 = 0.0
        
        # sum of products
        @sum_xy : Float64 = 0.0
        
        # number of observations
        @n : Int32 = 0
        
        # mean of accumulated x values, used in updating formulas
        @xbar : Float64 = 0.0
        
        # mean of accumulated y values, used in updating formulas
        @ybar : Float64 = 0.0
        
        # include an intercept or not
        @has_intercept : Bool = true
        
        # Create an empty SimpleRegression instance
        def initialize
            self.initialize(true)
        end
        
        # Create a SimpleRegression instance, specifying whether or not to estimate an intercept.
        # Use false to estimate a model with no intercept. When the hasIntercept property is false, the model is estimated without a constant term and getIntercept() returns 0.
        # Params:
        # includeIntercept – whether or not to include an intercept term in the regression model
        def initialize(@has_intercept)
        end
        
        # Returns the slope of the estimated regression line.
        # The least squares estimate of the slope is computed using the normal equations . The slope is sometimes denoted b1.
        # Preconditions:
        # At least two observations (with at least two different x values) must have been added before invoking this method. If this method is invoked before a model can be estimated, Double.NaN is returned.
        # Returns:
        # the slope of the regression line
        def get_slope() : Float64
            if @n < 2
                return Float64::NAN
            end
            if @sum_xx.abs < 10 * Float64::MIN
                return Float64::NAN
            end
            return @sum_xy / @sum_xx
        end
        
        # Returns the intercept of the estimated regression line, given the slope.
        # Will return NaN if slope is NaN.
        # Params:
        # slope – current slope
        # Returns:
        # the intercept of the regression line
        def get_intercept(slope : Float64) : Float64
            if @has_intercept
                return (@sum_y - slope * @sum_x) / @n
            end
            return 0.0
        end
        
        def add_data(x : Float64,  y : Float64) 
            if @n == 0
                @xbar = x
                @ybar = y
            elsif @has_intercept 
                fact1 = 1.0 + @n
                fact2 = @n / (1.0 + @n)
                dx = x - @xbar
                dy = y - @ybar
                @sum_xx += dx * dx * fact2
                @sum_yy += dy * dy * fact2
                @sum_xy += dx * dy * fact2
                @xbar += dx / fact1
                @ybar += dy / fact1
            end
            
            if !@has_intercept
                @sum_xx += x * x 
                @sum_yy += y * y 
                @sum_xy += x * y 
            end
            @sum_x += x
            @sum_y += y
            @n += 1
        end
    
        
        # Returns the intercept of the estimated regression line, if hasIntercept() is true; otherwise 0.
        # The least squares estimate of the intercept is computed using the normal equations . The intercept is sometimes denoted b0.
        # Preconditions:
        # At least two observations (with at least two different x values) must have been added before invoking this method. If this method is invoked before a model can be estimated, Double,NaN is returned.
        # Returns:
        # the intercept of the regression line if the model includes an intercept; 0 otherwise
        # See Also:
        # SimpleRegression(boolean)
        def get_intercept() : Float64
            return @has_intercept ? get_intercept(get_slope()) : 0.0
        end
    end
end
