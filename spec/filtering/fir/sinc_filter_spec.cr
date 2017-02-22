require "../../spec_helper"

ORDER = 16
SAMPLE_RATE = 5000.0
WINDOW_CLASS = Window::BlackmanHarris

describe SincFilter do
  context "odd order" do
    it "should raise ArgumentError" do
      [1,3,5,7].each do |order|
        expect_raises {
          SincFilter.new(order: order, sample_rate: SAMPLE_RATE, cutoff_freq: 100.0,
            window_class: WINDOW_CLASS)
        }
      end
    end
  end

  context "non-positive sample rate" do
    it "should raise ArgumentError" do
      [-1.0, 0.0].each do |sample_rate|
        expect_raises {
          SincFilter.new(order: 16, sample_rate: sample_rate, cutoff_freq: 100.0,
            window_class: WINDOW_CLASS)
        }
      end
    end
  end

  context "cutoff freq greater than half sample rate" do
    it "should raise ArgumentError" do
      [(SAMPLE_RATE / 2.0) + 1.0, SAMPLE_RATE * 0.6].each do |cutoff_freq|
        expect_raises {
          SincFilter.new(order: 16, sample_rate: SAMPLE_RATE, cutoff_freq: cutoff_freq,
            window_class: WINDOW_CLASS)
        }
      end
    end
  end

  [60,80,100,120,140].each do |order|
    (Scale.exponential((SAMPLE_RATE/16)..(SAMPLE_RATE/8), 3)).each do |cutoff|

      filter = SincFilter.new(order: order, cutoff_freq: cutoff, sample_rate: SAMPLE_RATE,
        window_class: WINDOW_CLASS)

      describe "#highpass" do
        it "should keep magnitude below-20 dB below cutoff and close to 0 dB above cutoff" do
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
        it "should keep magnitude below-20 dB above cutoff and close to 0 dB below cutoff" do
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
