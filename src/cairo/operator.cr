module Cairo
  # `Operator` is used to set the compositing operator for all cairo drawing operations.
  #
  # The default operator is `Operator::Over`.
  #
  # The operators marked as unbounded modify their destination even outside of the mask layer
  # (that is, their effect is not bound by the mask layer). However, their effect can still be limited by way of clipping.
  #
  # To keep things simple, the operator descriptions here document the behavior for when both source and destination are either fully transparent
  # or fully opaque. The actual implementation works for translucent layers too.
  # For a more detailed explanation of the effects of each operator, including the mathematical definitions,
  # see [https://cairographics.org/operators/](https://cairographics.org/operators/).
  enum Operator
    # Clear destination layer (bounded).
    Clear

    # Replace destination layer (bounded).
    Source

    # Draw source layer on top of destination layer.
    Over

    # Draw source where there was destination content (unbounded).
    In

    # Draw source where there was no destination content (unbounded).
    Out

    # Draw source on top of destination content and only there.
    Atop

    # Ignore the source.
    Dest

    # Draw destination on top of source.
    DestOver

    # Leave destination only where there was source content (unbounded).
    DestIn

    # Leave destination only where there was no source content.
    DestOut

    # Leave destination on top of source content and only there (unbounded).
    DestAtop

    # Source and destination are shown where there is only one of them.
    Xor

    # Source and destination layers are accumulated.
    Add

    # Like over, but assuming source and dest are disjoint geometries.
    Saturate

    # Source and destination layers are multiplied. This causes the result to be at least as dark as the darker inputs.
    Multiply

    # Source and destination are complemented and multiplied. This causes the result to be at least as light as the lighter inputs.
    Screen

    # Multiplies or screens, depending on the lightness of the destination color.
    Overlay

    # Replaces the destination with the source if it is darker, otherwise keeps the source.
    Darken

    # Replaces the destination with the source if it is lighter, otherwise keeps the source.
    Lighten

    # Brightens the destination color to reflect the source color.
    ColorDodge

    # Darkens the destination color to reflect the source color.
    ColorBurn

    # Multiplies or screens, dependent on source color.
    HardLight

    # Darkens or lightens, dependent on source color.
    SoftLight

    # Takes the difference of the source and destination color.
    Difference

    # Produces an effect similar to difference, but with lower contrast.
    Exclusion

    # Creates a color with the hue of the source and the saturation and luminosity of the target.
    HslHue

    # Creates a color with the saturation of the source and the hue and luminosity of the target.
    # Painting with this mode onto a gray area produces no change.
    HslSaturation

    # Creates a color with the hue and saturation of the source and the luminosity of the target.
    # This preserves the gray levels of the target and is useful for coloring monochrome images or tinting color images.
    HslColor

    # Creates a color with the luminosity of the source and the hue and saturation of the target.
    # This produces an inverse effect to `Operator::HslColor`.
    HslLuminosity
  end
end
