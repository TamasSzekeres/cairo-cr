module Cairo
  # Specifies the type of antialiasing to do when rendering text or shapes.
  #
  # As it is not necessarily clear from the above what advantages a particular antialias method provides,
  # there is also a set of hints:
  # - `Antialias::Fast` : Allow the backend to degrade raster quality for speed
  # - `Antialias::Good` : A balance between speed and quality
  # - `Antialias::Best` : A high-fidelity, but potentially slow, raster mode
  #
  # These make no guarantee on how the backend will perform its rasterisation (if it even rasterises!),
  # nor that they have any differing effect other than to enable some form of antialiasing.
  # In the case of glyph rendering, `Antialias::Fast` and `Antialias::Good` will be mapped to `Antialias::Gray`,
  # with `Antialias::Best` being equivalent to `Antialias::Subpixel`.
  #
  # The interpretation of `Antialias::Default` is left entirely up to the backend,
  # typically this will be similar to `Antialias::Good` .
  enum Antialias
    # Use the default antialiasing for the subsystem and target device.
    Default

    # Use a bilevel alpha mask.
    None

    # Perform single-color antialiasing (using shades of gray for black text on a white background, for example).
    Gray

    # Perform antialiasing by taking advantage of the order of subpixel elements on devices such as LCD panels.
    Subpixel

    # Hint that the backend should perform some antialiasing but prefer speed over quality.
    Fast

    # The backend should balance quality against performance
    Good

    # Hint that the backend should render at the highest quality, sacrificing speed if necessary.
    Best
  end
end
