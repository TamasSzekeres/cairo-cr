module Cairo
  # Specifies the type of antialiasing to do when rendering text or shapes.
  #
  # As it is not necessarily clear from the above what advantages a particular antialias method provides,
  # there is also a set of hints:
  # - `Antialias::AntialiasFast` : Allow the backend to degrade raster quality for speed
  # - `Antialias::AntialiasGood` : A balance between speed and quality
  # - `Antialias::AntialiasBest` : A high-fidelity, but potentially slow, raster mode
  #
  # These make no guarantee on how the backend will perform its rasterisation (if it even rasterises!),
  # nor that they have any differing effect other than to enable some form of antialiasing.
  # In the case of glyph rendering, `Antialias::AntialiasFast` and `Antialias::AntialiasGood` will be mapped to `Antialias::AntialiasGray`,
  # with `Antialias::AntialiasBest` being equivalent to `Antialias::AntialiasSubpixel`.
  #
  # The interpretation of `Antialias::AntialiasDefault` is left entirely up to the backend,
  # typically this will be similar to `Antialias::AntialiasGood` .
  enum Antialias
    # Use the default antialiasing for the subsystem and target device.
    AntialiasDefault

    # Use a bilevel alpha mask.
    AntialiasNone

    # Perform single-color antialiasing (using shades of gray for black text on a white background, for example).
    AntialiasGray

    # Perform antialiasing by taking advantage of the order of subpixel elements on devices such as LCD panels.
    AntialiasSubpixel

    # Hint that the backend should perform some antialiasing but prefer speed over quality.
    AntialiasFast

    # The backend should balance quality against performance
    AntialiasGood

    # Hint that the backend should render at the highest quality, sacrificing speed if necessary.
    AntialiasBest
  end
end
