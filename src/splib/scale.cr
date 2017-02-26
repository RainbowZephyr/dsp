module Splib

# Provide methods for generating sequences that scale linearly or exponentially.
class Scale
  # Produce a sequence of values that progresses in a linear fashion.
  # @param [Range] range The start and end values the set should include.
  # @param [Fixnum] n_points The number of points to create for the sequence, including the start and end points.
  # @raise [ArgumentError] if n_points is < 2.
  def self.linear(range, n_points)
    raise ArgumentError.new("n_points is < 2") if n_points < 2
    incr = (range.end - range.begin) / (n_points - 1)
    value = range.begin

    Array.new(n_points) do |i|
      x = value
      value += incr
      x
    end
  end

  # Produce a sequence of values that progresses in an exponential fashion.

  # @param [Range] range The start and end values the set should include.
  # @param [Fixnum] n_points The number of points to create for the sequence, including the start and end points.
  # @raise [ArgumentError] if n_points is < 2.
  def self.exponential(range, n_points)
    raise ArgumentError.new("n_points is < 2") if n_points < 2
    multiplier = (range.end / range.begin)**(1.0/(n_points-1))
    value = range.begin

    Array.new(n_points) do |i|
      x = value
      value *= multiplier
      x
    end
  end
end

end
