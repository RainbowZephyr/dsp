module Splib

# Linear and polynomial interpolation methods
class Interpolation#(T)
  ZERO_TO_ONE = 0.0..1.0

  private def self.check_relative_x_distance(x)
    unless ZERO_TO_ONE.includes?(x)
      raise ArgumentError.new("relative x distance #{x} is not between 0.0 and 1.0")
    end
  end

  # Linear interpolator
  # Given 2 sample points, interpolates a value anywhere between.
  #
  # @param [Numeric] y0 First (left) y-value
  # @param [Numeric] y1 Second (right) y-value
  # @param [Numeric] x Amount of interpolation (0.0 to 1.0)
  def self.linear(y0, y1, x : Float64)
    check_relative_x_distance(x)
    return y0 + x * (y1 - y0)
  end

  # 4-point, 3rd-order (cubic) Hermite interpolater (x-form).
  #
  # Given 4 evenly-spaced sample points, interpolate a value anywhere between
  # the middle two points.
  #
  # implementation source: www.musicdsp.org/archive.php?classid=5#93
  #
  # @param [Float] y0 First y-value
  # @param [Float] y1 Second y-value (first middle point)
  # @param [Float] y2 Third y-value (second middle point)
  # @param [Float] y3 Fourth y-value
  # @param [Float] rel_dist Relative distance (0.0 to 1.0) along the x-axis between the two middle
  #                         points, at which to interpolate
  def self.cubic(y0, y1, y2, y3, x : Float64)
    check_relative_x_distance(x)

    ## method 1 (slowest)
    #c0 = y1
    #c1 = 0.5 * (y2 - y0)
    #c2 = y0 - 2.5 * y1 + 2*y2 - 0.5 * y3
    #c3 = 1.5 * (y1 - y2) + 0.5 * (y3 - y0)

    # method 2 (basically tied with method 3)
    c0 = y1
    c1 = 0.5 * (y2 - y0)
    c3 = 1.5 * (y1 - y2) + 0.5 * (y3 - y0)
    c2 = y0 - y1 + c1 - c3

    ## method 3 (basically tied with method 2)
    #c0 = y1
    #c1 = 0.5 * (y2 - y0)
    #y0my1 = y0 - y1
    #c3 = (y1 - y2) + 0.5 * (y3 - y0my1 - y2)
    #c2 = y0my1 + c1 - c3

    return ((c3 * x + c2) * x + c1) * x + c0
  end
end

end
