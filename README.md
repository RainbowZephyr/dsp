# DSP

Signal processing library written in Crystal (high-level and fast).

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  dsp:
    github: https://github.com/RainbowZephyr/dsp
```

## Features

* FFT Planner, multiple optimized FFT implementations (forward and inverse)
* Windows (Blackman, Hamming, etc.)
* Windowed sinc filtering (lowpass, highpass, bandpass, bandstop)

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
TODO: Write more usage instructions here

## Contributing

1. Fork it ( https://github.com/[your-github-name]/dsp/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [jamestunnell](https://github.com/jamestunnell) James Tunnell - creator, maintainer
- [RainbowZephyr](https://github.com/RainbowZephyr)
