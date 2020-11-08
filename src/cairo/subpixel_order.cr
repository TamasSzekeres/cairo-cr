module Cairo
  # The subpixel order specifies the order of color elements within each
  # pixel on the display device when rendering with an antialiasing mode of `Antialias::Subpixel`.
  enum SubpixelOrder
    # Use the default subpixel order for for the target device.
    Default

    # Subpixel elements are arranged horizontally with red at the left.
    RGB

    # Subpixel elements are arranged horizontally with blue at the left.
    BGR

    # Subpixel elements are arranged vertically with red at the top.
    VRGB

    # Subpixel elements are arranged vertically with blue at the top.
    VBGR
  end
end
