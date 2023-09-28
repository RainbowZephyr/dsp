require "../../spec_helper"

sample_rate = 4000.0

describe DualSincFilter do
  [200].each do |order|
    [{500.0,700.0}, {800.0,1000.0}].each do |left_cutoff, right_cutoff|
      center = (left_cutoff + right_cutoff) / 2.0
      bandwidth = right_cutoff - left_cutoff

      filter = DualSincFilter.new(order: order, left_cutoff: left_cutoff, right_cutoff: right_cutoff, sample_rate: sample_rate, window_class: Window::Blackman)

      describe "#bandpass" do
        it "should restrict magnitude below left cutoff and above right cutoff, and preseve it in between" do
          freq_response_db = filter.bandpass_fir.freq_response_db


          freq_response_db.each do |freq, magn_db|
            if (freq <= (0.6*left_cutoff)) || (freq >= (1.4*right_cutoff))
              magn_db.should be < -20.0
            elsif (freq <= (0.8*left_cutoff)) || (freq >= (1.2*right_cutoff))
              magn_db.should be < -10.0
            elsif (freq <= left_cutoff) || (freq >= right_cutoff)
              magn_db.should be < 0.0
            elsif (freq <= (left_cutoff + 0.25 * bandwidth)) || (freq >= (right_cutoff - 0.25 * bandwidth))
              magn_db.should be_close(-2.0,2.0)
            else
              magn_db.should be_close(0.0,2.0)
            end
          end
        end
      end

      describe "#bandstop" do
        it "should preserve magnitude below left cutoff and above right cutoff, and restrict it in between" do
          freq_response_db = filter.bandstop_fir.freq_response_db
          freq_response_db.each do |freq, magn_db|
            
            if (freq <= (0.8*left_cutoff)) || (freq >= (1.2*right_cutoff))
              magn_db.should be_close(0.0,2.0)
            elsif (freq <= left_cutoff) || (freq >= right_cutoff)
              magn_db.should be < 0.1
            elsif (freq <= (left_cutoff + 0.25 * bandwidth)) || (freq >= (right_cutoff - 0.25 * bandwidth))
              magn_db.should be < -8.0
            else
              magn_db.should be < -15.0
            end
          end
        end
      end

    end
  end
end
