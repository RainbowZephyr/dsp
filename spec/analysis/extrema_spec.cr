require "../spec_helper"

describe Extrema do
  sample_arrays = [
    [-3.5, 4.7, -3.5, 2.7, -2.2, -0.1, -0.08, 3.1, 0.8, 0.3, 4.8, 4.5, 4.1],
    [-5.3, 0.3, 5.3, 0.7, -2.2, -0.2, 3.6, -5.6, -2.8, 1.0, 5.3, -3.6, 4.1],
    [4.3, 3.6, 5.4, -5.6, 2.2, 0.7, -5.2, 4.7, 0.3, 0.0, -0.4, 2.8, -1.8],
  ]

  describe "#minima" do
    context "global minimum not at endpoint" do
      it "should return sample indices mapped to all minima" do
        {
          [0.1, 0.0, 1.1, 0.9, 1.0] => { 1 => 0.0, 3 => 0.9 },
          [0.5, 0.0, -0.5, 0.25, 0.5, 0.25, 0.5, 0.25] => { 2 => -0.5, 5 => 0.25}
        }.each do |samples, expected_minima|
          Extrema.new(samples).local_minima.should eq(expected_minima)
        end
      end
    end

    context "global minimum at endpoint" do
      it "should return sample indices mapped to all minima, including endpoint with global minimum" do
        {
          [-1.2, 0.0, 1.1, 0.9, 1.0] => { 0 => -1.2, 3 => 0.9 },
          [1.0, 0.0, 1.1, 0.9, -1.3] => { 1 => 0.0, 4 => -1.3 },
        }.each do |samples, expected_minima|
          Extrema.new(samples).minima.should eq(expected_minima)
        end
      end
    end

  end

  describe "#maxima" do
    context "global maximum not at endpoint" do
      it "should return sample indices mapped to all maxima, and not include endpoints" do
        {
          [-1.2, 0.0, 1.1, 0.9, 1.0] => { 2 => 1.1 },
          [0.5, 0.0, -0.5, 0.25, 0.51, 0.25, 0.5, 0.25] => { 4 => 0.51, 6 => 0.5}
        }.each do |samples, expected_maxima|
          Extrema.new(samples).maxima.should eq(expected_maxima)
        end
      end
    end

    context "global maximum at endpoint" do
      it "should return sample indices mapped to all maxima, including endpoint with global maximum" do
        {
          [-1.2, 0.0, 1.1, 0.9, 1.2] => { 2 => 1.1, 4 => 1.2 },
          [1.3, 0.0, 1.1, 0.9, 1.2] => { 0 => 1.3, 2 => 1.1 },
        }.each do |samples, expected_maxima|
          Extrema.new(samples).maxima.should eq(expected_maxima)
        end
      end
    end
  end

  describe "#extrema" do
    it "should return minima + maxima" do
      sample_arrays.each do |samples|
        e = Extrema.new(samples)
        e.extrema.should eq(e.minima.merge(e.maxima))
      end
    end
  end

  describe "#negative_minima" do
    sample_arrays.each do |samples|
      e = Extrema.new(samples)
      e.negative_minima.values.each { |x| x.should be <= 0.0 }
    end
  end

  describe "#positive_maxima" do
    sample_arrays.each do |samples|
      e = Extrema.new(samples)
      e.positive_maxima.values.each { |x| x.should be >= 0.0 }
    end
  end

  describe "#outer_extrema" do
    it "should return negative_minima + postive_maxima" do
      sample_arrays.each do |samples|
        e = Extrema.new(samples)
        e.outer_extrema.should eq(e.negative_minima.merge(e.positive_maxima))
      end
    end
  end
end
