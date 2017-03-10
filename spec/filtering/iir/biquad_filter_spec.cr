require "../../spec_helper"
require "./filter_helper"

describe BiquadFilter do
  sample_rate = 2000.0
  min_test_freq = 20.0
  max_test_freq = 900.0
  ntest_points = 101

  describe "#process_samples" do
    [
      CookbookHighpassFilter, CookbookLowpassFilter, CookbookBandpassFilter,
      CookbookBandstopFilter, CookbookAllpassFilter
    ].each do |biquad_subclass|
      context biquad_subclass.to_s do
        [100.0, 200.0, 300.0].each do |critical_freq|
          filter = biquad_subclass.new(critical_freq: critical_freq, q: 1.0, sample_rate: sample_rate)
          context "Critical freq of #{critical_freq}" do
            it "should be close to ideal filter response for a range of frequencies" do
              abs_error_sum = 0.0
              max_abs_error = 0.0

              test_freqs = Scale.linear(min_test_freq..max_test_freq, ntest_points)
              test_freqs.map do |test_freq|
                actual_magn_db = test_actual_filter_magnitude_response_db(filter, test_freq, nperiods: 200)
                ideal_magn_db = filter.magnitude_response_db(test_freq)
                abs_error = (actual_magn_db - ideal_magn_db).abs

                abs_error_sum += abs_error
                if abs_error > max_abs_error
                  max_abs_error = abs_error
                end
              end

              max_abs_error.should be < 5.0

              avg_abs_error = abs_error_sum / test_freqs.size
              avg_abs_error.should be_close(0.0, 1.0)
            end
          end
        end
      end
    end
  end
end
