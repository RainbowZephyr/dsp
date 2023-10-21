module DSP::LAlgebra
  class Solver
    @qrt : Array(Array(Float64)) 
    @r_diag : Array(Float64)
    @threshold : Float64

    def initialize(@qrt, @r_diag, @threshold)
    end

    def non_singular? : Bool
      return @r_diag.all? { |diag| diag.abs > @threshold }
    end

    def solve_vector(b : LA::GMat) : LA::GMat
        n = @qrt.size
        m = @qrt[0].size

        raise ArgumentError.new("Dimension mismatch") if b.nrows != m
        raise ArgumentError.new("Singular matrix") unless non_singular?

        x : Array(Float64) = Array.new(n, 0.0)
        y : Array(Float64) = b.to_a

        (0...Math.min(m, n)).each { |minor|
            qrt_minor : Array(Float64) = @qrt[minor]
            dot_product : Float64 = 0.0

            (minor...m).each { |row| dot_product += y[row] * qrt_minor[row] }

            dot_product /= @r_diag[minor] * qrt_minor[minor]

            (minor...m).each { |row| y[row] += dot_product * qrt_minor[row] }

        }   

        (@r_diag.size - 1).downto(0) { |row|
            y[row] /= @r_diag[row]
            y_row = y[row]
            qrt_row : Array(Float64) = @qrt[row]
            x[row] = y_row
            (0...row).each { |i| y[i] -= y_row * qrt_row[i] }
        }

      return LA::GMat.new(x.size, 1, x)
    end

    # def get_inverse
    #   solve(Matrix.eye(@qrt[0].size))
    # end
  end
end
