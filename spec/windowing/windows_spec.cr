require "../spec_helper"

window_classes = [
  DSP::Windows::Rectangular,
  DSP::Windows::Hann,
  DSP::Windows::Hamming,
  DSP::Windows::Cosine,
  DSP::Windows::Lanczos,
  DSP::Windows::Triangular,
  DSP::Windows::Gaussian,
  DSP::Windows::BartlettHann,
  DSP::Windows::Blackman,
  DSP::Windows::Nuttall,
  DSP::Windows::BlackmanHarris,
  DSP::Windows::BlackmanNuttall,
  DSP::Windows::Tukey
]

TOLERANCE = 1e-6

window_classes.each do |window_class|
  describe window_class do
    [2,3,4,5,8,11,16,35,40,100,117].each do |size|
      describe "for size #{size}" do
        window = window_class.get(size)

        it "should be symmetric" do
          (size // 2).times do |i|
            x1 = window[i]
            x2 = window[size - 1 - i]
            x1.should be_close(x2, TOLERANCE)
          end
        end

        # for odd sizes only
        if (size % 2) == 1
          it "should be 1.0 at center point" do
            window[size // 2].should be_close(1.0, TOLERANCE)
          end
        end

        it "should be maximum at center point(s)" do
          window[size // 2].should eq(window.max)
        end

        it "should be in range [0,1] for all points" do
          window.each do |x|
            if x < 0.0
              x.should be_close(0.0, TOLERANCE)
            elsif x > 1.0
              x.should be_close(1.0, TOLERANCE)
            end
          end
        end

        it "should be monotonically increasing before center" do
          (1..(size // 2)).each do |i|
            x1 = window[i-1]
            x2 = window[i]
            (x2-x1).should be >= 0.0
          end
        end

        it "should be monotonically decreasing after center" do
          (((size // 2)+1)...size).each do |i|
            x1 = window[i-1]
            x2 = window[i]
            (x2-x1).should be <= 0.0
          end
        end
      end
    end
  end
end
