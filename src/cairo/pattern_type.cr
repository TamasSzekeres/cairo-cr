module Cairo
  # `PatternType` is used to describe the type of a given pattern.
  #
  # The type of a pattern is determined by the function used to create it.
  # The `Pattern#create_rgb` and `Pattern#create_rgba` functions create `PatternType::Solid` patterns.
  #
  # The pattern type can be queried with `Pattern#type`.
  #
  # Most `Pattern` functions can be called with a pattern of any type,
  # (though trying to change the extend or filter for a solid pattern will have no effect).
  # A notable exception is `Pattern#add_color_stop` which must only be called with gradient patterns
  # (either `PatternType::Linear` or `PatternType::Radial`). Otherwise the pattern will be shutdown and put into an error state.
  #
  # New entries may be added in future versions.
  enum PatternType
    # The pattern is a solid (uniform) color. It may be opaque or translucent.
    Solid

    # The pattern is a based on a surface (an image).
    Surface

    # The pattern is a linear gradient.
    Linear

    # The pattern is a radial gradient.
    Radial

    # The pattern is a mesh.
    Mesh

    # The pattern is a user pattern providing raster data.
    RasterSource
  end
end
