require "../spec_helper"

describe Interpolation do
  describe ".linear" do
     args_expected_result_map = {
        {5.0, 10.0, 0.0} => 5.0,
        {5.0, 10.0, 1.0} => 10.0,
        {5.0, 10.0, 0.5} => 7.5,
        {-24.0, 24.0, 0.25} => -12.0,
        {-24.0, 24.0, 0.75} => 12.0,
     }
    it "should interpolate floating-point values" do
      args_expected_result_map.each do |args, expected_result|
         Interpolation.linear(*args).should eq(expected_result)
      end
    end

    it "should interpolate integer values" do
      args_expected_result_map.each do |args, expected_result|
         y0, y1, x = args
         Interpolation.linear(y0.to_i, y1.to_i, x).should eq(expected_result)
      end
    end
  end

  describe ".cubic" do
    context "relative x-distance is 0.0" do
      it "should produce intepolated value be equal to inner" do
        5.times do
          y0, y1, y2, y3 = rand, rand, rand, rand
          Interpolation.cubic(y0, y1, y2, y3, 0.0).should be_close(y1, 1e-10)
        end
      end
    end

    context "relative x-distance is 1.0" do
      it "should produce intepolated value be equal to inner" do
        5.times do
          y0, y1, y2, y3 = rand, rand, rand, rand
          Interpolation.cubic(y0, y1, y2, y3, 1.0).should be_close(y2, 1e-10)
        end
      end
    end

    context "four identical y values" do
      it "should return y value same as the others, no matter the relative x distance" do
        Interpolation.cubic(5.0, 5.0, 5.0, 5.0, 0.0).should eq(5.0)
        Interpolation.cubic(5.0, 5.0, 5.0, 5.0, 0.5).should eq(5.0)
        Interpolation.cubic(5.0, 5.0, 5.0, 5.0, 1.0).should eq(5.0)
      end
    end

    context "two outer values are equal to eachother" do
      [-2.5,0.0,1.3].each do |outer|
        context "two inner values are equal to eachother (but not equal to outer)" do
          context "inner values are greater than outer" do
            inner = outer + 1.0

            context "relative x-distance is > 0.0 and < 1.0" do
              it "should produce intepolated value greater than inner" do
                Scale.linear(0.01..0.99, 5).each do |x|
                  Interpolation.cubic(outer, inner, inner, outer, x).should be > inner
                end
              end
            end
          end

          context "inner values are greater than outer" do
            inner = outer - 1.0

            context "relative x-distance is > 0.0 and < 1.0" do
              it "should produce intepolated value less than inner" do
                Scale.linear(0.01..0.99, 5).each do |x|
                  Interpolation.cubic(outer, inner, inner, outer, x).should be < inner
                end
              end
            end
          end
        end
      end
    end

    context "first two values are equal to eachother, and last two values are equal to eachother" do
      y01 = 2.5
      y23 = 3.5

      context "relative x-distance is 0.5" do
        it "should produce value halfway in between first two and last two" do
          Interpolation.cubic(y01, y01, y23, y23, 0.5).should be_close(3.0, 1e-12)
        end
      end

      context "relative x-distance is < 0.5" do
        it "should produce value closer to first two" do
          Scale.linear(0.01..0.49, 5).each do |x|
            y = Interpolation.cubic(y01, y01, y23, y23, x)
            (y - y01).should be > 0.0
            (y - y01).should be < (y23 - y)
          end
        end
      end

      context "relative x-distance is > 0.5" do
        it "should produce value closer to last two" do
          Scale.linear(0.51..0.99, 5).each do |x|
            y = Interpolation.cubic(y01, y01, y23, y23, x)
            (y23 - y).should be > 0.0
            (y23 - y).should be < (y - y01)
          end
        end
      end
    end
  end
end
