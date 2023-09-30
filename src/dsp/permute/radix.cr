module DSP::Permute
  # Permutes array where size = base ^ x, x is a whole number
  def self.radix_in_place(arr : Array, base : Int32)
    # permuted = arr.map { |e| e }
    size = arr.size

    exponent = Math.log(size, base)
    if exponent.floor != exponent.round(12)
      raise ArgumentError.new("Input size #{size} is not power of #{base}")
    end

    # Defined to be arrays of long in C which is 32bit
    nt = Array(Int32).new(32, 0)
    kt = Array(Int32).new(32, 0)

    x = 0
    nt[0] = base - 1
    kt[0] = 1

    while true
      z = kt[x] * base
      if (z > size)
        break
      end
      x += 1
      kt[x] = z
      nt[x] = nt[x - 1] * base
    end

    # here: size == p**x
    i : Int32 = 0
    j : Int32 = 0
    while i < size - 1
      if (i < j)
        tmp = arr[i]
        arr[i] = arr[j]
        arr[j] = tmp
      end

      t = x - 1
      k = nt[t] # =^= k = (r-1) * n / r
      while (k <= j)
        j = (j - k).to_i
        t -= 1
        k = nt[t] # =^= k /= r
      end

      j += kt[t].to_i # =^= j += (k/(r-1))
      i += 1
    end
  end

  def self.radix(arr : Array, base : Int32) : Array
    permuted = arr.map { |e| e }
    radix_in_place(permuted, base)
    return permuted
  end
end
