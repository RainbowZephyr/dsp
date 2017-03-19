module Splib

# Features analysis methods.
class Extrema
  getter :local_minima, :local_maxima

  @local_minima = {} of Int32 => Float64
  @local_maxima = {} of Int32 => Float64
  @local_extrema = {} of Int32 => Float64

  @global_min_val = Float64::MAX
  @global_min_idx = 0
  @global_max_val = Float64::MIN
  @global_max_idx = 0

  @idx = 0
  @last_sample = 0.0
  @local_extrema_search_state_machine = LocalExtremaSearchStateMachine.new(0.0)

  def none_processed?
    @idx <= 0
  end

  def any_processed?
    @idx > 0
  end

  def ==(other : Extrema)
    (self.minima == other.minima) && (self.maxima == other.maxima)
  end

  def initialize
  end

  def initialize(samples : Array(Float64))
    process_samples(samples)
  end

  def process_sample(sample : Float64)
    update_global_min(sample)
    update_global_max(sample)
    update_local_extrema(sample)
    @idx += 1
  end

  def process_samples(samples : Array(Float64))
    samples.each {|x| process_sample(x)}
  end

  def update_global_min(sample)
    if none_processed? || sample < @global_min_val
      @global_min_idx = @idx
      @global_min_val = sample
    end
  end

  def update_global_max(sample)
    if none_processed? || sample > @global_max_val
      @global_max_idx = @idx
      @global_max_val = sample
    end
  end

  def update_local_extrema(sample)
    if any_processed?
      diff = sample - @last_sample
      @local_extrema_search_state_machine.process(diff)

      if @local_extrema_search_state_machine.found_minima
        @local_minima[@idx-1] = @last_sample
      elsif @local_extrema_search_state_machine.found_maxima
        @local_maxima[@idx-1] = @last_sample
      end
    end

    @last_sample = sample
  end

  def minima
    if any_processed?
      @local_minima.merge({@global_min_idx => @global_min_val})
    else
      @local_minima
    end
  end

  def maxima
    if any_processed?
      @local_maxima.merge({@global_max_idx => @global_max_val})
    else
      @local_maxima
    end
  end

  def extrema
    self.minima.merge(self.maxima)
  end

  # Returns only negative minima and positive maxima
  def outer_extrema
    negative_minima.merge(positive_maxima)
  end

  # Returns only negative minima
  def negative_minima
    minima.select {|idx,val| val <= 0 }
  end

  # Returns only positive maxima
  def positive_maxima
    maxima.select {|idx,val| val >= 0 }
  end

  class LocalExtremaSearchStateMachine
    POSITIVE_DIFF = :positive_diff
    NEGATIVE_DIFF = :negative_diff
    ZERO_DIFF = :zero_diff

    getter :found_minima, :found_maxima

    def initialize(first_diff : Float64)
      @found_minima = @found_maxima = false
      @prev_diff_type = uninitialized Symbol
      @prev_diff_type = diff_type(first_diff)
      @prev_prev_diff_type = @prev_diff_type
    end

    def diff_type(diff : Float64) : Symbol
      if diff == 0.0
        ZERO_DIFF
      elsif diff < 0.0
        NEGATIVE_DIFF
      else
        POSITIVE_DIFF
      end
    end

    def process(diff)
      @found_minima = false
      @found_maxima = false
      current_diff_type = diff_type(diff)

      case current_diff_type
      when POSITIVE_DIFF
        @found_minima = (@prev_diff_type == NEGATIVE_DIFF) ||
          (@prev_diff_type == ZERO_DIFF && @prev_prev_diff_type == NEGATIVE_DIFF)
      when NEGATIVE_DIFF
        @found_maxima = (@prev_diff_type == POSITIVE_DIFF) ||
          (@prev_diff_type == ZERO_DIFF && @prev_prev_diff_type == POSITIVE_DIFF)
      end

      if current_diff_type != @prev_diff_type
        @prev_prev_diff_type = @prev_diff_type
        @prev_diff_type = current_diff_type
      end
    end
  end

end

end
