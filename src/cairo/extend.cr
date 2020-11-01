module Cairo
  # `Extend` is used to describe how pattern color/alpha will be determined for areas "outside"
  # the pattern's natural area, (for example, outside the surface bounds or outside the gradient geometry).
  #
  # Mesh patterns are not affected by the extend mode.
  #
  # The default extend mode is `Extend::None` for surface patterns and `Extend::Pad` for gradient patterns.
  #
  # New entries may be added in future versions.
  enum Extend
    # Pixels outside of the source pattern are fully.
    None

    # The pattern is tiled by repeating.
    Repeat

    # The pattern is tiled by reflecting at the edges.
    Reflect

    # Pixels outside of the pattern copy the closest pixel from the source.
    Pad
  end
end
