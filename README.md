# cairo-cr

[Cairo](https://cairographics.org/) bindings for Crystal language.

[![Build Status](https://travis-ci.org/TamasSzekeres/cairo-cr.svg?branch=master)](https://travis-ci.org/TamasSzekeres/cairo-cr)
[![Dependency Status](https://shards.rocks/badge/github/TamasSzekeres/cairo-cr/status.svg)](https://shards.rocks/github/TamasSzekeres/cairo-cr)
[![devDependency Status](https://shards.rocks/badge/github/TamasSzekeres/cairo-cr/dev_status.svg)](https://shards.rocks/github/TamasSzekeres/cairo-cr)

## Installation

First install cairo:
```bash
sudo apt-get install libcairo2 libcairo2-dev
```

Add this to your application's `shard.yml`:

```yaml
dependencies:
  x11:
    github: TamasSzekeres/x11-cr
    branch: master

  cairo:
    github: TamasSzekeres/cairo-cr
    branch: master
```
Then run in terminal:
```bash
crystal deps
```

See also: [x11-cr](https://github.com/TamasSzekeres/x11-cr)

## Usage

```crystal
require "x11"
require "cairo"

module YourModule
  include X11
  include CairoCr
end
```

For more details see the sample in [/sample](/sample) folder.

## Sample

Build and run the sample:
```bash
  mkdir bin
  crystal build -o bin/sample sample/simple_window.cr --release
  ./bin/sample

```
![Simple Window](https://raw.githubusercontent.com/TamasSzekeres/cairo-cr/master/sample/simple-window.png)

## Contributing

1. Fork it ( https://github.com/TamasSzekeres/cairo-cr/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [TamasSzekeres](https://github.com/TamasSzekeres) Tamás Szekeres - creator, maintainer
