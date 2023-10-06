# DSP

Signal processing library written in Crystal (high-level and fast).

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  dsp:
    github: RainbowZephyr/dsp
```

## Features

* FFT Planner, multiple optimized FFT implementations (forward and inverse)
* Windows (Blackman, Hamming, etc.)
* Windowed sinc filtering (lowpass, highpass, bandpass, bandstop)
* Signal Detrending

## Usage

```crystal
require "dsp"
```

### FFT
```crystal
require "dsp"
waveform  = Array(Float64).new(16384) { |e| Random.rand }
transformed : Array(Complex) = DSP::Transforms::FFTPlanner.fft(waveform)
inverse : Array(Complex) = DSP::Transforms::FFTPlanner.ifft(transformed)
```
### Detrend
```crystal
# Linear
waveform = [1,2,3,4]
hash = Analysis::Detrend.apply(waveform) # {:detrended => ...., :trend_line => ...}

waveform = [1,2,3,4]
hash = Analysis::Detrend.apply(waveform, DSP::Analysis::Mode::POLYNOMIAL, 15) # {:detrended => ...., :trend_line => ...}
```

TODO: Write more usage instructions here

## Contributing

1. Fork it ( https://github.com/[your-github-name]/dsp/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [jamestunnell](https://github.com/jamestunnell) James Tunnell - creator
- [RainbowZephyr](https://github.com/RainbowZephyr) Maintainer
