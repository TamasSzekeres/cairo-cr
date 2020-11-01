module Cairo
  # `Filter` is used to indicate what filtering should be applied when reading pixel values from patterns.
  # See `Pattern#filter=` for indicating the desired filter to be used with a particular pattern.
  enum Filter
    # A high-performance filter, with quality similar to `Filter::Nearest`.
    Fast

    # A reasonable-performance filter, with quality similar to `Filter::Bilinear`.
    Good

    # The highest-quality available, performance may not be suitable for interactive use.
    Best

    # Nearest-neighbor filtering.
    Nearest

    # Linear interpolation in two dimensions.
    Bilinear

    # This filter value is currently unimplemented, and should not be used in current code.
    Gaussian
  end
end
