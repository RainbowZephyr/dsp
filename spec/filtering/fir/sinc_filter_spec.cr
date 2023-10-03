require "../../spec_helper"

ORDER        =     16
SAMPLE_RATE  = 5000.0
WINDOW_CLASS = DSP::Windows::BlackmanHarris

describe SincFilter do
  context "odd order" do
    it "should raise NonEvenError" do
      [1, 3, 5, 7].each do |order|
        expect_raises(NonEvenError) {
          SincFilter.new(order: order, sample_rate: SAMPLE_RATE, cutoff: 100.0,
            window_class: WINDOW_CLASS)
        }
      end
    end
  end

  context "non-positive sample rate" do
    it "should raise NonPositiveError" do
      expect_raises(NonPositiveError) {
        SincFilter.new(order: 16, sample_rate: -1.0, cutoff: 100.0,
          window_class: WINDOW_CLASS)
      }
    end
  end

  context "cutoff freq greater than half sample rate" do
    it "should raise ArgumentError" do
      [(SAMPLE_RATE / 2.0) + 1.0, SAMPLE_RATE * 0.6].each do |cutoff|
        expect_raises(ArgumentError) {
          SincFilter.new(order: 16, sample_rate: SAMPLE_RATE, cutoff: cutoff,
            window_class: WINDOW_CLASS)
        }
      end
    end
  end

  [80, 100, 120, 140].each do |order|
    (Scale.exponential((SAMPLE_RATE/16)..(SAMPLE_RATE/8), 3)).each do |cutoff|
      filter = SincFilter.new(order: order, cutoff: cutoff, sample_rate: SAMPLE_RATE,
        window_class: WINDOW_CLASS)

      describe "#highpass" do
        it "should restrict magnitude below cutoff and preserve it above cutoff" do
          filter.highpass_fir.freq_response_db.each do |freq, magnitude_db|
            if freq <= (0.6 * cutoff)
              magnitude_db.should be < -20.0
            elsif freq <= (0.8 * cutoff)
              magnitude_db.should be < -5.0
            elsif freq <= (1.2 * cutoff)
              magnitude_db.should be < 0.0
            elsif freq > (1.2 * cutoff)
              magnitude_db.should be_close(0.0, 2.0)
            end
          end
        end
      end

      describe "#lowpass" do
        it "should preserve magnitude below cutoff and restrict it above cutoff" do
          filter.lowpass_fir.freq_response_db.each do |freq, magnitude_db|
            if freq >= (1.4 * cutoff)
              magnitude_db.should be < -20.0
            elsif freq >= (1.2 * cutoff)
              magnitude_db.should be < -5.0
            elsif freq >= (0.8 * cutoff)
              magnitude_db.should be < 0.0
            elsif freq < (0.8 * cutoff)
              magnitude_db.should be_close(0.0, 2.0)
            end
          end
        end
      end
    end
  end
end
