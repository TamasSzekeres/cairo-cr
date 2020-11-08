module Cairo
  # Specifies the type of hinting to do on font outlines.
  # Hinting is the process of fitting outlines to the pixel grid in order to improve the appearance of the result.
  # Since hinting outlines involves distorting them, it also reduces the faithfulness to the original outline shapes.
  # Not all of the outline hinting styles are supported by all font backends.
  #
  # New entries may be added in future versions.
  enum HintStyle
    # Use the default hint style for font backend and target device.
    Default

    # Do not hint outlines.
    None

    # Hint outlines slightly to improve contrast while retaining good fidelity to the original shapes.
    Slight

    # Hint outlines with medium strength giving a compromise between fidelity to the original shapes and contrast.
    Medium

    # Hint outlines to maximize contrast.
    Full
  end
end
