require "complex"

module CommonMath
  def self.exponents(size : Int32) : Array(Int32)
    base = [8, 5, 4, 3, 2]
    result = Array(Int32).new
    base.each { |e|
      exponent = Math.log(size, e)
      if exponent.floor == (exponent.round(12))
        result << e
      end
    }
    result << 0
    return result
  end
end
