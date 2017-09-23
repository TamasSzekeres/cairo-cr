require "./lib_cairo"

{% if Cairo::C::HAS_XLIB_SURFACE %}
  require "x11"

  module Cairo::C
    include X11;

    @[Link("cairo")]
    lib LibCairo
      fun xlib_surface_create = cairo_xlib_surface_create(
        dpy : X::PDisplay,
        drawable : Drawable,
        visual : X::PVisual,
        width : Int32,
        height : Int32
      ) : PSurfaceT

      fun xlib_surface_create_for_bitmap = cairo_xlib_surface_create_for_bitmap(
        dpy : X::PDisplay,
        bitmap : Pixmap,
        screen : X::PScreen,
        width : Int32,
        height : Int32
      ) : PSurfaceT

      fun xlib_surface_set_size = cairo_xlib_surface_set_size(
        surface : PSurfaceT,
        width : Int32,
        height : Int32
      ) : Void

      fun xlib_surface_set_drawable = cairo_xlib_surface_set_drawable(
        surface : PSurfaceT,
        drawable : Drawable,
        width : Int32,
        height : Int32
      ) : Void

      fun xlib_surface_get_display = cairo_xlib_surface_get_display(
        surface : PSurfaceT
      ) : X::PDisplay

      fun xlib_surface_get_drawable = cairo_xlib_surface_get_drawable(
        surface : PSurfaceT
      ) : Drawable

      fun xlib_surface_get_screen = cairo_xlib_surface_get_screen(
        surface : PSurfaceT
      ) : X::PScreen

      fun xlib_surface_get_visual = cairo_xlib_surface_get_visual(
        surface : PSurfaceT
      ) : X::PVisual

      fun xlib_surface_get_depth = cairo_xlib_surface_get_depth(
        surface : PSurfaceT
      ) : Int32

      fun xlib_surface_get_width = cairo_xlib_surface_get_width(
        surface : PSurfaceT
      ) : Int32

      fun xlib_surface_get_height = cairo_xlib_surface_get_height(
        surface : PSurfaceT
      ) : Int32

      # debug interface

      fun xlib_device_debug_cap_xrender_version = cairo_xlib_device_debug_cap_xrender_version(
        device : PDeviceT,
        major_version : Int32,
        minor_version : Int32
      ) : Void

      # @precision: -1 implies automatically choose based on antialiasing mode,
      #            any other value overrides and sets the corresponding PolyMode.
      fun xlib_device_debug_set_precision = cairo_xlib_device_debug_set_precision(
        device : PDeviceT,
        precision : Int32
      ) : Void

      fun xlib_device_debug_get_precision = cairo_xlib_device_debug_get_precision(
        device : PDeviceT,
      ) : Int32
    end # lib LibCairo
  end # module Cairo::C
{% else %} # Cairo::C::HAS_XLIB_SURFACE
  puts "Cairo was not compiled with support for the xlib backend"
{% end %} # Cairo::C::HAS_XLIB_SURFACE
