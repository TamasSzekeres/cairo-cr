module Cairo
  # Used by the `PdfSurface#add_outline` function specify the attributes of an
  # outline item. These flags may be bitwise-or'd to produce any combination
  # of flags.
  @[Flags]
  enum PdfOutlineFlags
    # The outline item defaults to open in the PDF viewer.
    Open = 0x1

    # The outline item is displayed by the viewer in bold text.
    Bold = 0x2

    # The outline item is displayed by the viewer in italic text.
    Italic = 0x4
  end
end
