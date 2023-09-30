module DSP

# Implement a "cookbook" allpass filter using the BiquadFilter class,
# based on the well-known RBJ biquad filter.
class CookbookAllpassFilter < BiquadFilter
  def compute_coefficients(omega)
    cos_omega = Math.cos(omega)
    sin_omega = Math.sin(omega)
    alpha = Math.sin(omega) / (2.0 * @q)

    b0 = 1.0 - alpha
    b1 = -2.0 * cos_omega
    b2 = 1.0 + alpha
    a0 = b2
    a1 = b1
    a2 = b0

    return { a0, a1, a2, b0, b1, b2 }
  end
end

end
