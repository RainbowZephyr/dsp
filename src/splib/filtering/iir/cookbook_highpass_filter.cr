module Splib

# Implement a "cookbook" highpass filter using the BiquadFilter class,
# based on the well-known RBJ biquad filter.
class CookbookHighpassFilter < BiquadFilter
  # getter :q
  #
  # def initialize(critical_freq : Float64, @q : Float64, sample_rate : Float64)
  #   super(critical_freq: critical_freq, sample_rate: sample_rate)
  # end

  def compute_coefficients(omega)
    cos_omega = Math.cos(omega)
    sin_omega = Math.sin(omega)
    alpha = Math.sin(omega) / (2.0 * @q)

    one_plus_cos_omega = 1.0 + cos_omega
    one_plus_cos_omega_over_two = one_plus_cos_omega * 0.5

    b0 = one_plus_cos_omega_over_two
    b1 = -one_plus_cos_omega
    b2 = one_plus_cos_omega_over_two
    a0 = 1.0 + alpha
    a1 = -2.0 * cos_omega
    a2 = 1.0 - alpha

    return { a0, a1, a2, b0, b1, b2 }
  end
end

end
