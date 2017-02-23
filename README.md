[![Build Status](https://travis-ci.org/jamestunnell/splib.svg?branch=master)](https://travis-ci.org/jamestunnell/splib)

# splib

Signal processing library written in Crystal (high-level and fast).

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  splib:
    github: https://github.com/jamestunnell/splib
```

## Features

* FFT transform (forward and inverse)
* Windows (Blackman, Hamming, etc.)
* Windowed sinc filtering (lowpass, highpass, bandpass, bandstop)

## Usage

```crystal
require "splib"
```

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/[your-github-name]/splib/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [jamestunnell](https://github.com/jamestunnell) James Tunnell - creator, maintainer
