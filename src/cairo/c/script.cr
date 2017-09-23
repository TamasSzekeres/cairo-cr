require "./lib_cairo"

{% if Cairo::C::HAS_SCRIPT_SURFACE %}
  module Cairo::C
    @[Link("cairo")]
    lib LibCairo
      enum ScriptModeT
        MODE_ASCII,
        MODE_BINARY
      end

      fun script_create = cairo_script_create(
        filename : UInt8
      ) : PDeviceT

      fun script_create_for_stream = cairo_script_create_for_stream(
        write_func : WriteFuncT,
        closure : Void*
      ) : PDeviceT

      fun script_write_comment = cairo_script_write_comment(
        script : PDeviceT,
        comment : UInt8*,
        len : Int32
      ) : Void

      fun script_set_mode = cairo_script_set_mode(
        script : PDeviceT,
        mode : ScriptModeT
      ) : Void

      fun script_get_mode = cairo_script_get_mode(
        script : PDeviceT
      ) : ScriptModeT

      fun script_surface_create = cairo_script_surface_create(
        script : PDeviceT,
        content : ContentT,
        width : Float64,
        height : Float64
      ) : PSurfaceT

      fun script_surface_create_for_target = cairo_script_surface_create_for_target(
        script : PDeviceT,
        target : PSurfaceT
      ) : PSurfaceT

      fun script_from_recording_surface = cairo_script_from_recording_surface(
        script : PDeviceT,
        recording_surface : PSurfaceT
      ) : StatusT
    end # lib LibCairo
  end # module Cairo::C
{% else %} # Cairo::C::HAS_SCRIPT_SURFACE
puts "Cairo was not compiled with support for the CairoScript backend"
{% end %} # Cairo::C::HAS_SCRIPT_SURFACE
