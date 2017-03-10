require "../../spec_helper"
require "./filter_helper"

describe CookbookBandstopFilter do
  sample_rate = 2000.0
  min_test_freq = 20.0
  max_test_freq = 900.0
  ntest_points = 101

  context "q of 1.0" do
    q = 1.0

    l_corner_mul = 0.5
    r_corner_mul = 1.5

    [100.0, 200.0, 300.0].each do |critical_freq|
      filter = CookbookBandstopFilter.new(critical_freq: critical_freq, q: q, sample_rate: sample_rate)
      l_corner = critical_freq * l_corner_mul
      r_corner = critical_freq * r_corner_mul

      # puts "critical freq: #{critical_freq}"
      # puts "freq\tmagdb"
      # Scale.linear(min_test_freq..max_test_freq, ntest_points).map do |test_freq|
      #   puts "#{test_freq}\t#{filter.magnitude_response_db(test_freq)}"
      # end
      # puts

      describe "#magnitude_response_db" do
        it "should have less than -15 dB gain when very near critical freq" do
          filter.magnitude_response_db(critical_freq-0.1).should be < -25.0
          filter.magnitude_response_db(critical_freq+0.1).should be < -25.0
        end

        it "should be between -4 and 0 dB at L/R corners" do
          l_magn_db = filter.magnitude_response_db(l_corner)
          l_magn_db.should be < 0.0
          l_magn_db.should be > -4.0

          r_magn_db = filter.magnitude_response_db(r_corner)
          r_magn_db.should be < 0.0
          r_magn_db.should be > -4.0
        end

        it "should be descending up to critical_freq" do
          lefthand_magn_db = Scale.linear(min_test_freq..(critical_freq-1.0), ntest_points).map do |test_freq|
            filter.magnitude_response_db(test_freq)
          end
          verify_descending(lefthand_magn_db)
        end

        it "should be ascending past critical_freq" do
          righthand_magn_db = Scale.linear((critical_freq+1.0)..max_test_freq, ntest_points).map do |test_freq|
            filter.magnitude_response_db(test_freq)
          end
          verify_ascending(righthand_magn_db)
        end
      end
    end
  end
end
