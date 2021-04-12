require "./c/lib_cairo"
require "./c/features"
require "./c/xlib"

{% if Cairo::C::HAS_XLIB_SURFACE %}

require "x11"

module Cairo
  include X11
  include Cairo::C

  # The Xlib surface is used to render cairo graphics to
  # X Window System windows and pixmaps using the XLib library.
  #
  # NOTE: that the XLib surface automatically takes advantage
  # of X render extension if it is available.
  class XlibSurface < Surface
    # Creates an Xlib surface that draws to the given drawable. The way that
    # colors are represented in the drawable is specified by the provided visual.
    #
    # NOTE: If drawable is a Window, then the function `XlibSurface#set_size`
    # must be called whenever the size of the window changes.
    #
    # When drawable is a Window containing child windows then drawing to the
    # created surface will be clipped by those child windows. When the created
    # surface is used as a source, the contents of the children will be included.
    #
    # ###Parameters
    # - **dpy** an X Display
    # - **drawable** an X Drawable, (a `Pixmap` or a `Window`)
    # - **visual** the visual to use for drawing to *drawable*.
    # The depth of the visual must match the depth of the drawable.
    # Currently, only TrueColor visuals are fully supported.
    # - **width** the current width of *drawable*.
    # - **height** the current height of *drawable*.
    #
    # ###Returns
    # The newly created surface.
    def initialize(dpy : Display, drawable : Drawable, visual : Visual, width : Int32, height : Int32)
      super(LibCairo.xlib_surface_create(dpy.to_unsafe, drawable, visual.to_unsafe, width, height))
    end

    # Creates an Xlib surface that draws to the given bitmap.
    # This will be drawn to as a `Format::A1` object.
    #
    # ###Parameters
    # - **dpy** an X Display
    # - **bitmap** an X Drawable, (a depth-1 `Pixmap`)
    # - **screen** the X Screen associated with bitmap
    # - **width** the current width of *bitmap*.
    # - **height** the current height of *bitmap*.
    #
    # ###Returns
    # The newly created surface.
    def initialize(dpy : Display, bitmap : Pixmap, screen : Screen, width : Int32, height : Int32)
      super(LibCairo.xlib_surface_create_for_bitmap(dpy.to_unsafe, bitmap, screen.to_unsafe, width, height))
    end

    # Informs cairo of the new size of the X Drawable underlying the surface.
    # For a surface created for a Window (rather than a `Pixmap`),
    # this function must be called each time the size of the window changes.
    # (For a subwindow, you are normally resizing the window yourself, but for
    # a toplevel window, it is necessary to listen for ConfigureNotify events.)
    #
    # A `Pixmap` can never change size, so it is never necessary to call this
    # function on a surface created for a `Pixmap`.
    #
    # ###Parameters
    # - **width** the new width of the surface
    # - **height** the new height of the surface
    def set_size(width : Int32, height : Int32)
      LibCairo.xlib_surface_set_size(to_unsafe, width, height)
      self
    end

    # Informs cairo of a new X Drawable underlying the surface.
    # The drawable must match the display, screen and format of the existing
    # drawable or the application will get X protocol errors and will probably
    # terminate. No checks are done by this function to ensure this compatibility.
    #
    # ###Parameters
    # - **drawable** the new drawable for the surface
    # - **width** the width of the new drawable
    # - **height** the height of the new drawable
    def set_drawable(drawable : Drawable, width : Int32, height : Int32)
      LibCairo.xlib_surface_set_drawable(to_unsafe, drawable, width, height)
      self
    end

    # Get the X Display for the underlying X Drawable.
    #
    # ###Returns
    # The display.
    def display : Display
      Display.new(LibCairo.xlib_surface_get_display(to_unsafe))
    end

    # Get the underlying X Drawable used for the surface.
    #
    # ###Returns
    # The drawable.
    def drawable : Drawable
      LibCairo.xlib_surface_get_drawable(to_unsafe)
    end

    # Get the X Screen for the underlying X Drawable.
    #
    # ###Returns
    # The screen.
    def screen : Screen
      Screen.new(LibCairo.xlib_surface_get_screen(to_unsafe))
    end

    # Gets the X Visual associated with *surface*, suitable for use with
    # the underlying X Drawable. If *surface* was created by
    # `XlibSurface#initialize`, the return value is the Visual passed
    # to that constructor.
    #
    # ###Returns
    # The Visual or `nil` if there is no appropriate Visual for *surface*.
    def visual : Visual
      Visual.new(LibCairo.xlib_surface_get_visual(to_unsafe))
    end

    # Get the number of bits used to represent each pixel value.
    #
    # ###Returns
    # The depth of the surface in bits.
    def depth : Int32
      LibCairo.xlib_surface_get_depth(to_unsafe)
    end

    # Get the width of the X Drawable underlying the surface in pixels.
    #
    # ###Returns
    # The width of the surface in pixels.
    def width : Int32
      LibCairo.xlib_surface_get_width(to_unsafe)
    end

    # Get the height of the X Drawable underlying the surface in pixels.
    #
    # ###Returns
    # The height of the surface in pixels.
    def height : Int32
      LibCairo.xlib_surface_get_height(to_unsafe)
    end
  end
end

{% end %}
