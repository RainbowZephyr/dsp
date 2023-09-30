require "../spec_helper"
require "../../src/dsp/transforms/*"

describe DSP::Transforms do
  it "Hilbert" do
    input = [1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0]

    actual : Array(Complex) = DSP::Transforms::Hilbert.transform(input)
    expected : Array(Complex) = [Complex.new(1.0, -7.07106781e-01), Complex.new(1.0, +0.00000000e+00), Complex.new(1.0, -2.77555756e-17), Complex.new(1.0, +7.07106781e-01), Complex.new(0.0, +7.07106781e-01), Complex.new(0.0, +0.00000000e+00), Complex.new(0.0, +2.77555756e-17), Complex.new(0.0, -7.07106781e-01)]

    actual = actual.map { |e| e.round(9) }
    expected = expected.map { |e| e.round(9) }

    actual.should eq(expected)
  end

  it "Hilbert medium" do
    input = (1..64).to_a

    actual : Array(Complex) = DSP::Transforms::Hilbert.transform(input)
    expected : Array(Complex) = [Complex.new(1.0, +73.16003892), Complex.new(2.0, +32.44910367), Complex.new(3.0, +32.44910367),
                                 Complex.new(4.0, +18.96619885), Complex.new(5.0, +18.96619885), Complex.new(6.0, +10.98175129),
                                 Complex.new(7.0, +10.98175129), Complex.new(8.0, +5.39212574), Complex.new(9.0, +5.39212574),
                                 Complex.new(10.0, +1.16348103), Complex.new(11.0, +1.16348103), Complex.new(12.0, -2.17331738),
                                 Complex.new(13.0, -2.17331738), Complex.new(14.0, -4.87000521), Complex.new(15.0, -4.87000521),
                                 Complex.new(16.0, -7.07666516), Complex.new(17.0, -7.07666516), Complex.new(18.0, -8.8893595),
                                 Complex.new(19.0, -8.8893595), Complex.new(20.0, -10.37266059), Complex.new(21.0, -10.37266059),
                                 Complex.new(22.0, -11.57141446), Complex.new(23.0, -11.57141446), Complex.new(24.0, -12.51734401),
                                 Complex.new(25.0, -12.51734401), Complex.new(26.0, -13.23295546), Complex.new(27.0, -13.23295546),
                                 Complex.new(28.0, -13.73392938), Complex.new(29.0, -13.73392938), Complex.new(30.0, -14.03060135),
                                 Complex.new(31.0, -14.03060135), Complex.new(32.0, -14.12885505), Complex.new(33.0, -14.12885505),
                                 Complex.new(34.0, -14.03060135), Complex.new(35.0, -14.03060135), Complex.new(36.0, -13.73392938),
                                 Complex.new(37.0, -13.73392938), Complex.new(38.0, -13.23295546), Complex.new(39.0, -13.23295546),
                                 Complex.new(40.0, -12.51734401), Complex.new(41.0, -12.51734401), Complex.new(42.0, -11.57141446),
                                 Complex.new(43.0, -11.57141446), Complex.new(44.0, -10.37266059), Complex.new(45.0, -10.37266059),
                                 Complex.new(46.0, -8.8893595), Complex.new(47.0, -8.8893595), Complex.new(48.0, -7.07666516),
                                 Complex.new(49.0, -7.07666516), Complex.new(50.0, -4.87000521), Complex.new(51.0, -4.87000521),
                                 Complex.new(52.0, -2.17331738), Complex.new(53.0, -2.17331738), Complex.new(54.0, +1.16348103),
                                 Complex.new(55.0, +1.16348103), Complex.new(56.0, +5.39212574), Complex.new(57.0, +5.39212574),
                                 Complex.new(58.0, +10.98175129), Complex.new(59.0, +10.98175129), Complex.new(60.0, +18.96619885),
                                 Complex.new(61.0, +18.96619885), Complex.new(62.0, +32.44910367), Complex.new(63.0, +32.44910367),
                                 Complex.new(64.0, +73.16003892)]

    actual = actual.map { |e| e.round(6) }
    expected = expected.map { |e| e.round(6) }

    actual.should eq(expected)
  end

  it "Hilbert long" do
    input = (1..125).to_a

    actual : Array(Complex) = DSP::Transforms::Hilbert.transform(input)
    expected : Array(Complex) = [Complex.new(1, +169.53357143), Complex.new(2, +89.96028871), Complex.new(3, +89.98542675),
                                 Complex.new(4, +63.47217046), Complex.new(5, +63.52247832), Complex.new(6, +47.62793348),
                                 Complex.new(7, +47.7034749), Complex.new(8, +36.36460135), Complex.new(9, +36.46547236),
                                 Complex.new(10, +27.66126238), Complex.new(11, +27.78759175), Complex.new(12, +20.59941165),
                                 Complex.new(13, +20.75136161), Complex.new(14, +14.68456905), Complex.new(15, +14.86233606),
                                 Complex.new(16, +9.62015248), Complex.new(17, +9.82396832), Complex.new(18, +5.21436761),
                                 Complex.new(19, +5.44450058), Complex.new(20, +1.33610373), Complex.new(21, +1.59286009),
                                 Complex.new(22, -2.1081676), Complex.new(23, -1.82444194), Complex.new(24, -5.18744899),
                                 Complex.new(25, -4.87636656), Complex.new(26, -7.9540501), Complex.new(27, -7.61517967),
                                 Complex.new(28, -10.44851849), Complex.new(29, -10.08138257), Complex.new(30, -12.70286911),
                                 Complex.new(31, -12.3069411), Complex.new(32, -14.74277081), Complex.new(33, -14.31747183),
                                 Complex.new(34, -16.58906914), Complex.new(35, -16.13376437), Complex.new(36, -18.25887255),
                                 Complex.new(37, -17.7728672), Complex.new(38, -19.76634374), Complex.new(39, -19.24887836),
                                 Complex.new(40, -21.12328639), Complex.new(41, -20.57353173), Complex.new(42, -22.33958708),
                                 Complex.new(43, -21.75663818), Complex.new(44, -23.42355256), Complex.new(45, -22.80642209),
                                 Complex.new(46, -24.38216995), Complex.new(47, -23.72978063), Complex.new(48, -25.22130921),
                                 Complex.new(49, -24.53248529), Complex.new(50, -25.94588182), Complex.new(51, -25.21933929),
                                 Complex.new(52, -26.55996532), Complex.new(53, -25.79430078), Complex.new(54, -27.06690124),
                                 Complex.new(55, -26.26057914), Complex.new(56, -27.46937149), Complex.new(57, -26.62070952),
                                 Complex.new(58, -27.76945723), Complex.new(59, -26.87660949), Complex.new(60, -27.96868307),
                                 Complex.new(61, -27.02962056), Complex.new(62, -28.06804857), Complex.new(63, -27.08053664),
                                 Complex.new(64, -28.06804857), Complex.new(65, -27.02962056), Complex.new(66, -27.96868307),
                                 Complex.new(67, -26.87660949), Complex.new(68, -27.76945723), Complex.new(69, -26.62070952),
                                 Complex.new(70, -27.46937149), Complex.new(71, -26.26057914), Complex.new(72, -27.06690124),
                                 Complex.new(73, -25.79430078), Complex.new(74, -26.55996532), Complex.new(75, -25.21933929),
                                 Complex.new(76, -25.94588182), Complex.new(77, -24.53248529), Complex.new(78, -25.22130921),
                                 Complex.new(79, -23.72978063), Complex.new(80, -24.38216995), Complex.new(81, -22.80642209),
                                 Complex.new(82, -23.42355256), Complex.new(83, -21.75663818), Complex.new(84, -22.33958708),
                                 Complex.new(85, -20.57353173), Complex.new(86, -21.12328639), Complex.new(87, -19.24887836),
                                 Complex.new(88, -19.76634374), Complex.new(89, -17.7728672), Complex.new(90, -18.25887255),
                                 Complex.new(91, -16.13376437), Complex.new(92, -16.58906914), Complex.new(93, -14.31747183),
                                 Complex.new(94, -14.74277081), Complex.new(95, -12.3069411), Complex.new(96, -12.70286911),
                                 Complex.new(97, -10.08138257), Complex.new(98, -10.44851849), Complex.new(99, -7.61517967),
                                 Complex.new(100, -7.9540501), Complex.new(101, -4.87636656), Complex.new(102, -5.18744899),
                                 Complex.new(103, -1.82444194), Complex.new(104, -2.1081676), Complex.new(105, +1.59286009),
                                 Complex.new(106, +1.33610373), Complex.new(107, +5.44450058), Complex.new(108, +5.21436761),
                                 Complex.new(109, +9.82396832), Complex.new(110, +9.62015248), Complex.new(111, +14.86233606),
                                 Complex.new(112, +14.68456905), Complex.new(113, +20.75136161), Complex.new(114, +20.59941165),
                                 Complex.new(115, +27.78759175), Complex.new(116, +27.66126238), Complex.new(117, +36.46547236),
                                 Complex.new(118, +36.36460135), Complex.new(119, +47.7034749), Complex.new(120, +47.62793348),
                                 Complex.new(121, +63.52247832), Complex.new(122, +63.47217046), Complex.new(123, +89.98542675),
                                 Complex.new(124, +89.96028871), Complex.new(125, +169.53357143)]

    actual = actual.map { |e| e.round(6) }
    expected = expected.map { |e| e.round(6) }

    actual.should eq(expected)
  end
end
