def test_actual_filter_magnitude_response_db(filter, freq, nperiods=25)
  filter.reset_state

  nsamples = (nperiods * (filter.sample_rate / freq)).to_i
  sine_data = SineOscillator.new(freq: freq, sample_rate: filter.sample_rate).samples(nsamples)
  filtered_sine_data = filter.process_samples(sine_data)
  abs_data = filtered_sine_data.map {|x| x.abs }
  extrema = Extrema(Float64).new(abs_data)


  maxima_sum = 0.0
  extrema.maxima.values.each {|x| maxima_sum += x }
  avg_maximum = maxima_sum / extrema.maxima.size

  return Gain.linear_to_db(avg_maximum)
end
