module DSP

class NonEvenError < Exception; end

def verify_even(value)
  if (value % 2) != 0
    raise NonEvenError.new("#{value} is not even")
  end
end

class NonPositiveError < Exception; end

def verify_positive(value)
  if value <= 0
    raise NonPositiveError.new("#{value} is not positive")
  end
end

end
