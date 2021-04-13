module Cairo::C
  HAS_FC_FONT = true
  HAS_FT_FONT = true
  HAS_GOBJECT_FUNCTIONS = true

  # Defined if the image surface backend is available.
  # The image surface backend is always built in.
  HAS_IMAGE_SURFACE = true

  HAS_MIME_SURFACE = true
  HAS_OBSERVER_SURFACE = true

  # Defined if the PDF surface backend is available.
  HAS_PDF_SURFACE = true

  # Defined if the PNG functions are available.
  HAS_PNG_FUNCTIONS = true

  # Defined if the PostScript surface backend is available.
  HAS_PS_SURFACE = true

  # Defined if the recording surface backend is available.
  HAS_RECORDING_SURFACE = true

  # Defined if the script surface backend is available.
  HAS_SCRIPT_SURFACE = true

  # Defined if the Microsoft Windows surface backend is available.
  HAS_WIN32_SURFACE = false

  # Defined if the SVG surface backend is available.
  HAS_SVG_SURFACE = true

  # Defined if the tee surface backend is available.
  HAS_TEE_SURFACE = true

  # Defined if the user font backend is available.
  HAS_USER_FONT = true

  # Defined if the Quartz surface backend is available.
  HAS_QUARTZ_SURFACE = false

  # Defined if the xcb surface backend is available.
  HAS_XCB_SURFACE = false
  HAS_XCB_SHM_FUNCTIONS = false

  # Defined if the Xlib surface backend is available.
  HAS_XLIB_SURFACE = true

  # Defined if the XLib/XRender surface functions are available.
  HAS_XLIB_XRENDER_SURFACE = false
end # module Cairo::C
