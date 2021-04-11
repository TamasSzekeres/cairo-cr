# cairo-cr

[Cairo](https://cairographics.org/) bindings for Crystal language.

![Crystal CI](https://github.com/TamasSzekeres/cairo-cr/actions/workflows/crystal.yml/badge.svg)
[![GitHub release](https://img.shields.io/github/release/TamasSzekeres/cairo-cr.svg)](https://github.com/TamasSzekeres/cairo-cr/releases)
[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://tamasszekeres.github.io/cairo-cr/)

## Installation

First install cairo:
```bash
sudo apt-get install libcairo2 libcairo2-dev
```

Add this to your application's `shard.yml`:

```yaml
dependencies:
  cairo:
    github: TamasSzekeres/cairo-cr
```
Then run in terminal:
```bash
shards install
```

See also: [x11-cr](https://github.com/TamasSzekeres/x11-cr)

## Usage

```crystal
require "x11"
require "cairo"

module YourModule
  include X11::C # for low-level usage
  include Cairo::C # for low-level usage
  include X11 # for high-level usage
  include Cairo # for high-level usage
end
```

For more details see the sample in [/examples](/examples) folder.

## Sample

Build and run the low-level sample:
```shell
  cd examples/sample_window
  shards build
  ./bin/sample_window
```
![Sample Window](https://raw.githubusercontent.com/TamasSzekeres/cairo-cr/master/examples/screenshot/sample_window.png)

Build and run the high-level sample:
```shell
  cd examples/sample_window_hl
  shards build
  ./bin/sample_window
```

## Documentation

You can generate documentation for yourself:
```shell
crystal doc
```
Then you can open `/docs/index.html` in your browser.

Or you can view last commited documentation online at: [https://tamasszekeres.github.io/cairo-cr/](https://tamasszekeres.github.io/cairo-cr/).

## Contributing

1. Fork it (<https://github.com/TamasSzekeres/cairo-cr/fork>)
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [Tamás Szekeres](https://github.com/TamasSzekeres) - creator, maintainer
