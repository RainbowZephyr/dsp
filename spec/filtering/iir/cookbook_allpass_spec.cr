require "../../spec_helper"

describe CookbookAllpassFilter do
  sample_rate = 2000.0

  min_test_freq = 20.0
  max_test_freq = 900.0
  ntest_points = 41

  context "q of 1.0" do
    q = 1.0

    [100.0, 200.0, 300.0].each do |critical_freq|
      filter = CookbookAllpassFilter.new(critical_freq: critical_freq, q: q, sample_rate: sample_rate)

      describe "#magnitude_response_db" do
        it "should have 0 dB gain at all freqs" do
          Scale.linear(min_test_freq..max_test_freq, ntest_points).map do |test_freq|
            magn_db = filter.magnitude_response_db(test_freq)
            magn_db.should be_close(0.0, 1.5)
          end
        end
      end
    end
  end
end
