require "./c/lib_cairo"
require "./c/features"
require "./c/xlib"

{% if Cairo::C::HAS_XLIB_SURFACE %}
  require "x11"

module Cairo
  include X11
  include Cairo::C

  class XlibSurface < Surface
    def initialize(dpy : Display, drawable : Drawable, visual : Visual, width : Int32, height : Int32)
      super(LibCairo.xlib_surface_create(dpy.to_unsafe, drawable, visual.to_unsafe, width, height))
    end

    def initialize(dpy : Display, bitmap : Pixmap, screen : Screen, width : Int32, height : Int32)
      super(LibCairo.xlib_surface_create_for_bitmap(dpy.to_unsafe, bitmap, screen.to_unsafe, width, height))
    end

    def set_size(width : Int32, height : Int32)
      LibCairo.xlib_surface_set_size(to_unsafe, width, height)
      self
    end

    def set_drawable(drawable : Drawable, width : Int32, height : Int32)
      LibCairo.xlib_surface_set_drawable(to_unsafe, drawable, width, height)
      self
    end

    def display : Display
      Display.new(LibCairo.xlib_surface_get_display(to_unsafe))
    end

    def drawable : Drawable
      LibCairo.xlib_surface_get_drawable(to_unsafe)
    end

    def screen : Screen
      Screen.new(LibCairo.xlib_surface_get_screen(to_unsafe))
    end

    def visual : Visual
      Visual.new(LibCairo.xlib_surface_get_visual(to_unsafe))
    end

    def depth : Int32
      LibCairo.xlib_surface_get_depth(to_unsafe)
    end

    def width : Int32
      LibCairo.xlib_surface_get_width(to_unsafe)
    end

    def height : Int32
      LibCairo.xlib_surface_get_height(to_unsafe)
    end
  end
end

{% end %}
