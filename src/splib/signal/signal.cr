require "complex"

module Splib

class Sig
  include Enumerable(Float64)

  getter :data, :sample_rate

  def initialize(@data : Array(Float64), @sample_rate : Float64)
    verify_positive(@sample_rate)
  end

  delegate size, each, to: @data

  def ==(other)
    (@sample_rate == other.sample_rate) && @data == other.data
  end

  def clone
    Sig.new(@data.clone, @sample_rate)
  end

  # Sig duration in seconds.
  def duration
    return @data.size.to_f / @sample_rate
  end

  # Calculate the energy in current signal data.
  def energy
    return @data.map {|x| x*x }.sum
  end

  # Calculate signal RMS (root-mean square), also known as quadratic mean, a
  # statistical measure of the magnitude.
  def rms
    Math.sqrt(energy / size)
  end

  # Operate on copy of the Sig object with the absolute value function.
  def abs
    Sig.new(@data.map {|x| x.abs}, @sample_rate)
  end

  def max_magnitude
    @data.map {|x| x.abs}.max
  end

  # adjust samples to maximum magnitude of 1
  def normalize(max_magn = 1.0)
    scale = max_magnitude / max_magn
    if scale != 0.0
      Sig.new(@data.map {|x| x / scale}, @sample_rate)
    else
      self.clone
    end
  end

  private def check_size_compatibility(other : Array(Float64))
    if other.size != size
      msg = "Other signal size #{other.size} does not equal current signal size #{size}"
      raise ArgumentError.new(msg)
    end
  end

  private def check_other_signal_compatibility(other : Sig)
    check_size_compatibility(other.data)

    if other.sample_rate != sample_rate
      msg = "Other signal sample rate #{other.sample_rate} does not equal current signal sample rate #{@sample_rate}"
      raise ArgumentError.new(msg)
    end
  end

  def +(other : Float64)
    Sig.new(@data.map {|x| x + other}, @sample_rate)
  end

  def +(other : Sig)
    check_other_signal_compatibility(other)
    Sig.new(Array.new(size){|i| @data[i] + other.data[i]}, @sample_rate)
  end

  def +(other : Array(Float64))
    check_size_compatibility(other)
    Sig.new(Array.new(size){|i| @data[i] + other[i]}, @sample_rate)
  end

  def -(other : Float64)
    Sig.new(@data.map {|x| x - other}, @sample_rate)
  end

  def -(other : Sig)
    check_other_signal_compatibility(other)
    Sig.new(Array.new(size){|i| @data[i] - other.data[i]}, @sample_rate)
  end

  def -(other : Array(Float64))
    check_size_compatibility(other)
    Sig.new(Array.new(size){|i| @data[i] - other[i]}, @sample_rate)
  end

  def *(other : Float64)
    Sig.new(@data.map {|x| x * other}, @sample_rate)
  end

  def *(other : Sig)
    check_other_signal_compatibility(other)
    Sig.new(Array.new(size){|i| @data[i] * other.data[i]}, @sample_rate)
  end

  def *(other : Array(Float64))
    check_size_compatibility(other)
    Sig.new(Array.new(size){|i| @data[i] * other[i]}, @sample_rate)
  end

  def /(other : Float64)
    Sig.new(@data.map {|x| x / other}, @sample_rate)
  end

  def /(other : Sig)
    check_other_signal_compatibility(other)
    Sig.new(Array.new(size){|i| @data[i] / other.data[i]}, @sample_rate)
  end

  def /(other : Array(Float64))
    check_size_compatibility(other)
    Sig.new(Array.new(size){|i| @data[i] / other[i]}, @sample_rate)
  end

  def extrema
    @extrema ||= Extrema(Float64).new @data
  end

  def frequency_domain
    @frequency_domain ||= FrequencyDomain.new(@data, @sample_rate)
  end
end

end
