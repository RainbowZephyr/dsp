require "spec"
require "../src/splib"

include Splib

def windowed_sine_signal(freq, sample_rate, size, window_class)
  signal_data = SineOscillator.new(freq: freq, sample_rate: sample_rate).samples(size)
  Sig.new(signal_data, sample_rate) * window_class.new(size)
end

def verify_ascending(seq)
  prev = seq[0]
  (1...seq.size).each do |i|
    cur = seq[i]
    cur.should be > prev

    prev = cur
  end
end

def verify_descending(seq)
  prev = seq[0]
  (1...seq.size).each do |i|
    cur = seq[i]
    cur.should be < prev

    prev = cur
  end
end
