module DSP

# Provide utility functions to convert between a linear and decibel (logarithm) unit.
module Gain

  MAX_DB_ABS = 6000.0

  # Convert a decibel value to a linear value.
  def self.db_to_linear(db)
    db_abs = db.abs
    raise ArgumentError.new("decibel value #{db} is more than allowed maximum #{MAX_DB_ABS}") if db_abs > MAX_DB_ABS
    raise ArgumentError.new("decibel value #{db} is less than allowed minimum #{-MAX_DB_ABS}") if db_abs < -MAX_DB_ABS
    return 10.0**(db / 20.0)
  end

  # Convert a linear value to a decibel value.
  def self.linear_to_db(linear)
    raise ArgumentError.new("linear value #{linear} is less than 0.0") if linear < 0.0
    if linear == 0.0
      return -MAX_DB_ABS
    else
      return 20.0 * Math.log10(linear)
    end
  end

end

end
