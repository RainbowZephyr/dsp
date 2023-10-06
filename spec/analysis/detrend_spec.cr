require "csv"
require "../spec_helper"

describe Analysis::Detrend do
  waveform = File.open("spec/sample_data/waveform.csv") do |file|
    CSV::Parser.new(file).parse.flat_map { |e| e[0].to_f }
  end

  it "Constant Detrend" do
    hash = Analysis::Detrend.apply(waveform, true)
    expected = File.open("spec/sample_data/constant_result.csv") do |file|
      CSV::Parser.new(file).parse.flat_map { |e| e[0].to_f }
    end

    actual = hash[:detrended]
    actual.map! { |e| e.round(9) }
    expected.map! { |e| e.round(9) }

    actual.should eq(expected)
  end


  it "Linear Detrend" do
    hash = Analysis::Detrend.apply(waveform)
    expected = File.open("spec/sample_data/linear_result.csv") do |file|
      CSV::Parser.new(file).parse.flat_map { |e| e[0].to_f }
    end

    actual = hash[:detrended]
    actual.map! { |e| e.round(9) }
    expected.map! { |e| e.round(9) }

    actual.should eq(expected)
  end

  # it "Polynomial Detrend" do
  #   hash = Analysis::Detrend.apply(waveform, Analysis::Mode::POLYNOMIAL, 15)
  #   expected = File.open("spec/sample_data/polynomial_result.csv") do |file|
  #     CSV::Parser.new(file).parse.flat_map { |e| e[0].to_f }
  #   end

  #   actual = hash[:detrended]
  #   actual = actual[0...12].map { |e| e.round(9) }
  #   expected = expected[0...12].map { |e| e.round(9) }

  #   actual.should eq(expected)
  # end
end
