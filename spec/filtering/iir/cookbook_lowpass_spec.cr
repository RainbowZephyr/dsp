require "../../spec_helper"

describe CookbookLowpassFilter do
  sample_rate = 2000.0

  min_test_freq = 20.0
  max_test_freq = 900.0
  ntest_points = 41

  context "q of 1.0" do
    q = 1.0

    [100.0, 200.0, 300.0].each do |critical_freq|
      filter = CookbookLowpassFilter.new(critical_freq: critical_freq, q: q, sample_rate: sample_rate)

      describe "#magnitude_response_db" do
        it "should have 0 dB gain at critical freq" do
          filter.magnitude_response_db(critical_freq).should be_close(0.0, 0.01)
        end

        it "should have close to 0dB gain below critical freq" do
          lefthand_magn_db = Scale.linear(min_test_freq..critical_freq, ntest_points).map do |test_freq|
            magn_db = filter.magnitude_response_db(test_freq)
            magn_db.should be_close(0.0, 1.5)
          end
        end

        it "should have be descending response above critical freq" do
          righthand_magn_db = Scale.linear(critical_freq..max_test_freq, ntest_points).map do |test_freq|
            filter.magnitude_response_db(test_freq)
          end
          verify_descending(righthand_magn_db)
        end

        it "should descend at least -10dB per octave above the critical freq" do
          octave_num = 1
          octave = critical_freq * 2
          while octave < (sample_rate / 2.0)
            magn_db = filter.magnitude_response_db(octave)
            magn_db.should be < (octave_num * -10.0)

            octave_num += 1
            octave *= 2.0
          end
        end
      end
    end
  end
end
