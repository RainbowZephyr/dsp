# require "../../spec_helper"
# require "../../src/dsp/transforms/*"

# describe DSP::Transforms do
#   it "Hilbert" do
#     input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]

#     actual : Array(Complex) = DSP::Transforms::Hilbert.transform(input)
#     expected : Array(Complex) = [Complex.new(1.0, -7.07106781e-01), Complex.new(1.0, +0.00000000e+00), Complex.new(1.0, -2.77555756e-17), Complex.new(1.0, +7.07106781e-01), Complex.new(0.0, +7.07106781e-01), Complex.new(0.0, +0.00000000e+00), Complex.new(0.0, +2.77555756e-17), Complex.new(0.0, -7.07106781e-01)]

#     actual = actual.map { |e| e.round(9) }
#     expected = expected.map { |e| e.round(9) }

#     actual.should eq(expected)
#   end

#   it "Hilbert long" do
#     input = (1..64).to_a

#     actual : Array(Complex) = DSP::Transforms::Hilbert.transform(input)
#     expected : Array(Complex) = [Complex.new(1.0, +73.16003892), Complex.new(2.0, +32.44910367), Complex.new(3.0, +32.44910367),
#                                  Complex.new(4.0, +18.96619885), Complex.new(5.0, +18.96619885), Complex.new(6.0, +10.98175129),
#                                  Complex.new(7.0, +10.98175129), Complex.new(8.0, +5.39212574), Complex.new(9.0, +5.39212574),
#                                  Complex.new(10.0, +1.16348103), Complex.new(11.0, +1.16348103), Complex.new(12.0, -2.17331738),
#                                  Complex.new(13.0, -2.17331738), Complex.new(14.0, -4.87000521), Complex.new(15.0, -4.87000521),
#                                  Complex.new(16.0, -7.07666516), Complex.new(17.0, -7.07666516), Complex.new(18.0, -8.8893595),
#                                  Complex.new(19.0, -8.8893595), Complex.new(20.0, -10.37266059), Complex.new(21.0, -10.37266059),
#                                  Complex.new(22.0, -11.57141446), Complex.new(23.0, -11.57141446), Complex.new(24.0, -12.51734401),
#                                  Complex.new(25.0, -12.51734401), Complex.new(26.0, -13.23295546), Complex.new(27.0, -13.23295546),
#                                  Complex.new(28.0, -13.73392938), Complex.new(29.0, -13.73392938), Complex.new(30.0, -14.03060135),
#                                  Complex.new(31.0, -14.03060135), Complex.new(32.0, -14.12885505), Complex.new(33.0, -14.12885505),
#                                  Complex.new(34.0, -14.03060135), Complex.new(35.0, -14.03060135), Complex.new(36.0, -13.73392938),
#                                  Complex.new(37.0, -13.73392938), Complex.new(38.0, -13.23295546), Complex.new(39.0, -13.23295546),
#                                  Complex.new(40.0, -12.51734401), Complex.new(41.0, -12.51734401), Complex.new(42.0, -11.57141446),
#                                  Complex.new(43.0, -11.57141446), Complex.new(44.0, -10.37266059), Complex.new(45.0, -10.37266059),
#                                  Complex.new(46.0, -8.8893595), Complex.new(47.0, -8.8893595), Complex.new(48.0, -7.07666516),
#                                  Complex.new(49.0, -7.07666516), Complex.new(50.0, -4.87000521), Complex.new(51.0, -4.87000521),
#                                  Complex.new(52.0, -2.17331738), Complex.new(53.0, -2.17331738), Complex.new(54.0, +1.16348103),
#                                  Complex.new(55.0, +1.16348103), Complex.new(56.0, +5.39212574), Complex.new(57.0, +5.39212574),
#                                  Complex.new(58.0, +10.98175129), Complex.new(59.0, +10.98175129), Complex.new(60.0, +18.96619885),
#                                  Complex.new(61.0, +18.96619885), Complex.new(62.0, +32.44910367), Complex.new(63.0, +32.44910367),
#                                  Complex.new(64.0, +73.16003892)]

#     actual = actual.map { |e| e.round(6) }
#     expected = expected.map { |e| e.round(6) }

#     actual.should eq(expected)
#   end
# end
