require "../../spec_helper"
require "./filter_helper"

describe CookbookBandpassFilter do
  sample_rate = 2000.0
  min_test_freq = 20.0
  max_test_freq = 900.0
  ntest_points = 101

  context "q of 1.0" do
    q = 1.0

    l_corner_mul = (2.0 / 3.0)
    r_corner_mul = (4.0 / 3.0)

    [100.0, 200.0, 300.0].each do |critical_freq|
      filter = CookbookBandpassFilter.new(critical_freq: critical_freq, q: q, sample_rate: sample_rate)
      l_corner = critical_freq * l_corner_mul
      r_corner = critical_freq * r_corner_mul

      describe "#magnitude_response_db" do
        it "should have 0 dB gain at critical freq" do
          filter.magnitude_response_db(critical_freq).should be_close(0.0, 0.01)
        end

        it "should be between -3 and 0 dB at L/R corners" do
          l_magn_db = filter.magnitude_response_db(l_corner)
          l_magn_db.should be < 0.0
          l_magn_db.should be > -3.0

          r_magn_db = filter.magnitude_response_db(r_corner)
          r_magn_db.should be < 0.0
          r_magn_db.should be > -3.0
        end

        it "should be ascending until critical freq" do
          lefthand_magn_db = Scale.linear(min_test_freq..critical_freq, ntest_points).map do |test_freq|
            filter.magnitude_response_db(test_freq)
          end
          verify_ascending(lefthand_magn_db)
        end

        it "should be descending after critical freq" do
          righthand_magn_db = Scale.linear(critical_freq..max_test_freq, ntest_points).map do |test_freq|
            filter.magnitude_response_db(test_freq)
          end
          verify_descending(righthand_magn_db)
        end
      end
    end
  end
end
