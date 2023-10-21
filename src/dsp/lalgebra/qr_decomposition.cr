# Crystal code to calculate the QR-decomposition of a matrix using Householder reflectors
# This code is translated from Java code provided by Apache Commons Math3

require "linalg"
require "./solver"

module DSP::LAlgebra
    class QRDecomposition
        
        @qrt : Array(Array(Float64))
        @r_diag : Array(Float64)
        @cached_q : LA::GMat?
        @cached_qt : LA::GMat?
        @cached_r : LA::GMat?
        @cached_h : LA::GMat?
        @threshold : Float64
        
        @q_cached : Bool = false
        @qt_cached : Bool = false
        @r_cached : Bool = false
        @h_cached : Bool = false
        
                
        def initialize(matrix : LA::GMat , threshold : Float64 = 0.0)
            @threshold = threshold
            
            m = matrix.nrows
            n = matrix.ncolumns
            
            @qrt = matrix.transpose.to_aa
            @r_diag = Array.new(Math.min(m, n), 0.0)

            @cached_q =  nil
            @cached_qt = nil
            @cached_r =  nil
            @cached_h =  nil
            decompose(@qrt)
        end
        
        protected def decompose(matrix : Array(Array(Float64)))
            (0...Math.min(matrix.size, matrix[0].size)).each { |minor|
                perform_householder_reflection(minor, matrix)
            }
        end
        
        protected def perform_householder_reflection(minor : Int32, matrix : Array(Array(Float64)))
            qrt_minor : Array(Float64) = matrix[minor]
            x_norm_sqr : Float64 = 0.0
            
            (minor...qrt_minor.size).each { |row|
             x_norm_sqr += qrt_minor[row] * qrt_minor[row]
            }
        
            a : Float64 = qrt_minor[minor] > 0 ? -Math.sqrt(x_norm_sqr) : Math.sqrt(x_norm_sqr)
            @r_diag[minor] = a
            
            if a != 0.0
                qrt_minor[minor] -= a
                
                ((minor+1)...matrix.size).each { |col|
                    qrt_col : Array(Float64) = matrix[col]
                    alpha : Float64 = 0.0

                    (minor...qrt_col.size).each { |row|
                        alpha -= qrt_col[row] * qrt_minor[row]
                    }

                    alpha /= a * qrt_minor[minor]
            
                    (minor...qrt_col.size).each { |row|
                        qrt_col[row] -= alpha * qrt_minor[row]
                    }
                }
            end
        end

        def get_r : LA::GMat
            if !@r_cached
                n = @qrt.size
                m = @qrt[0].size
                ra : Array(Array(Float64)) = Array.new(m) { Array.new(n, 0.0) }
            
                (Math.min(m, n) - 1).downto(0) { |row|
                    ra[row][row] = @r_diag[row]
                    ((row + 1)...n).each { |col|
                        ra[row][col] = @qrt[col][row]
                    }
                }
                @r_cached = true
                @cached_r = LA::GMat.new(ra)
            end
            return @cached_r.not_nil!
        end

        def get_q : LA::GMat
            if !@q_cached
                @cached_q = self.get_qt.not_nil!.t
                @q_cached = true
            end
            return @cached_q.not_nil!
        end

        def get_qt : LA::GMat
            if !@qt_cached
                n = @qrt.size
                m = @qrt[0].size
                qta : Array(Array(Float64)) = Array.new(m) { Array.new(m, 0.0) }
                
                (m - 1).downto(Math.min(m, n)) { |minor| qta[minor][minor] = 1.0}
                
                (Math.min(m, n) - 1).downto(0) { |minor|
                    qrt_minor = @qrt[minor]
                    qta[minor][minor] = 1.0
                    
                    next if qrt_minor[minor] == 0.0
                    
                    (minor...m).each { |col|
                        alpha = 0.0
                        
                        (minor...m).each { |row| alpha -= qta[col][row] * qrt_minor[row] }
                        alpha /= @r_diag[minor] * qrt_minor[minor]
                        
                        (minor...m).each { |row| qta[col][row] += -alpha * qrt_minor[row] }
                    }
                }
                @cached_qt = LA::GMat.new(qta)
                @qt_cached = true
            end

            return @cached_qt.not_nil!
        end

        def get_h : LA::GMat
            if @h_cached 
                n = @qrt.size
                m = @qrt[0].size
                ha = Array.new(m) { Array.new(n, 0.0) }
                
                m.times { |i|
                    Math.min(i + 1, n).times { |j| ha[i][j] = @qrt[j][i] / -@r_diag[j] }
                }
                @cached_h = LA::GMat.new(ha)
                @h_cached = true
            end

            return @cached_h.not_nil!
        end

        def get_solver : DSP::LAlgebra::Solver
            return DSP::LAlgebra::Solver.new(@qrt, @r_diag, @threshold)
        end

    end
end

