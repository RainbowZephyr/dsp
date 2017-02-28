module Splib

# Features analysis methods.
class Extrema(T)
  getter :minima, :maxima, :extrema

  def initialize(samples : Array(T))
    @minima = {} of Int32 => T
    @maxima = {} of Int32 => T
    @extrema = {} of Int32 => T
    compute_extrema(samples)
  end

  private def compute_extrema(samples : Array(T))
    global_min_idx = 0
    global_min_val = samples[0]
    global_max_idx = 0
    global_max_val = samples[0]

    diffs = [] of T
    (1...samples.size).each do |i|
      diffs.push(samples[i] - samples[i-1])

      if samples[i] < global_min_val
        global_min_idx = i
        global_min_val = samples[i]
      end

      if samples[i] > global_max_val
        global_max_idx = i
        global_max_val = samples[i]
      end
    end
    @minima[global_min_idx] = global_min_val
    @maxima[global_max_idx] = global_max_val

    lessm = LocalExtremaSearchStateMachine(T).new(diffs.first)

    # at diff zero crossings there is a local maxima/minima
    (1...diffs.size).each do |i|
      lessm.process(diffs[i])
      if lessm.found_minima
        @minima[i] = samples[i]
      elsif lessm.found_maxima
        @maxima[i] = samples[i]
      end
    end

    @extrema = @minima.merge(@maxima)
  end

  # Returns only negative minima and positive maxima
  def outer_extrema
    negative_minima.merge(positive_maxima)
  end

  # Returns only negative minima
  def negative_minima
    @minima.select {|idx,val| val <= 0 }
  end

  # Returns only positive maxima
  def positive_maxima
    @maxima.select {|idx,val| val >= 0 }
  end

  class LocalExtremaSearchStateMachine(T)
    POSITIVE_DIFF = :positive_diff
    NEGATIVE_DIFF = :negative_diff
    ZERO_DIFF = :zero_diff

    getter :found_minima, :found_maxima

    def initialize(first_diff : T)
      @found_minima = @found_maxima = false
      @prev_diff_type = uninitialized Symbol
      @prev_diff_type = diff_type(first_diff)
      @prev_prev_diff_type = @prev_diff_type
    end

    def diff_type(diff : T) : Symbol
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

      case @prev_diff_type
      when ZERO_DIFF
        case current_diff_type
        when POSITIVE_DIFF
          if @prev_prev_diff_type == NEGATIVE_DIFF
            @found_maxima = true
          end
        when NEGATIVE_DIFF
          if @prev_prev_diff_type == POSITIVE_DIFF
            @found_maxima = true
          end
        end
      when NEGATIVE_DIFF
        if current_diff_type == POSITIVE_DIFF
          @found_minima = true
        end
      when POSITIVE_DIFF
        if current_diff_type == NEGATIVE_DIFF
          @found_maxima = true
        end
      end

      if current_diff_type != @prev_diff_type
        @prev_prev_diff_type = @prev_diff_type
        @prev_diff_type = current_diff_type
      end
    end
  end

end

end
