module Cairo
  # `SurfaceType` is used to describe the type of a given surface.
  # The surface types are also known as "backends" or "surface backends" within cairo.
  #
  # The type of a surface is determined by the function used to create it,
  # which will generally be of the form `Surface#initialize`, (though see `Surface#create_similar` as well).
  #
  # The surface type can be queried with `Surface#type`.
  #
  # The various `Surface` functions can be used with surfaces of any type,
  # but some backends also provide type-specific functions that must only
  # be called with a surface of the appropriate type. These functions have names
  # that begin with cairo_type_surface such as `Surface#width`.
  #
  # The behavior of calling a type-specific function with a surface of the wrong type is undefined.
  #
  # New entries may be added in future versions.
  enum SurfaceType
    # The surface is of type image.
    Image

    # The surface is of type pdf.
    PDF

    # The surface is of type ps.
    PS

    # The surface is of type xlib.
    XLib

    # The surface is of type xcb.
    XCB

    # The surface is of type glitz.
    Glitz

    # The surface is of type quartz.
    Quartz

    # The surface is of type win32.
    Win32

    # The surface is of type beos.
    BEOS

    # The surface is of type directfb.
    DirectFB

    # The surface is of type svg.
    SVG

    # The surface is of type os2.
    OS2

    # The surface is a win32 printing surface.
    Win32Printing

    # The surface is of type quartz_image.
    QuartzImage

    # The surface is of type scrip.
    Script

    # The surface is of type Qt.
    Qt

    # The surface is of type recording.
    Recording

    # The surface is a OpenVG surface.
    VG

    # The surface is of type OpenGL.
    GL

    # The surface is of type Direct Render Manager.
    DRM

    # The surface is of type 'tee' (a multiplexing surface).
    Tee

    # The surface is of type XML (for debugging).
    XML

    # The surface is of type Skia.
    Skia

    # The surface is a subsurface created with `Surface#create_for_rectangle`.
    Subsurface

    # This surface is of type Cogl.
    COGL
  end
end
