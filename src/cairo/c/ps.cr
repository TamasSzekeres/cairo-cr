require "./lib_cairo"

{% if Cairo::C::HAS_PS_SURFACE %}
  module Cairo::C
    @[Link("cairo")]
    lib LibCairo
      # PS-surface functions

      enum PsLevelT
        LEVEL_2,
        LEVEL_3
      end

      fun ps_surface_create = cairo_ps_surface_create(
        filename : UInt8*,
        width_in_points : Float64,
        height_in_points : Float64
      ) : PSurfaceT

      fun ps_surface_create_for_stream = cairo_ps_surface_create_for_stream(
        write_func : WriteFuncT,
        closure : Void*,
        width_in_points : Float64,
        height_in_points : Float64
      ) : PSurfaceT

      fun ps_surface_restrict_to_level = cairo_ps_surface_restrict_to_level(
        surface : PSurfaceT,
        level : PsLevelT
      ) : Void

      fun ps_get_levels = cairo_ps_get_levels(
        levels : PsLevelT**,
        num_levels : Int32*
      ) : Void

      fun ps_level_to_string = cairo_ps_level_to_string(
        level : PsLevelT
      ) : UInt8*

      fun ps_surface_set_eps = cairo_ps_surface_set_eps(
        surface : PSurfaceT,
        eps : BoolT
      ) : Void

      fun ps_surface_get_eps = cairo_ps_surface_get_eps(
        surface : PSurfaceT
      ) : BoolT

      fun ps_surface_set_size = cairo_ps_surface_set_size(
        surface : PSurfaceT,
        width_in_points : Float64,
        height_in_points : Float64
      ) : Void

      fun ps_surface_dsc_comment = cairo_ps_surface_dsc_comment(
        surface : PSurfaceT,
        comment : UInt8*
      ) : Void

      fun ps_surface_dsc_begin_setup = cairo_ps_surface_dsc_begin_setup(
        surface : PSurfaceT
      ) : Void

      fun ps_surface_dsc_begin_page_setup = cairo_ps_surface_dsc_begin_page_setup(
        surface : PSurfaceT
      ) : Void
    end # lib LibCairo
  end # module Cairo::C
{% else %} # Cairo::C::HAS_PS_SURFACE
  puts "Cairo was not compiled with support for the ps backend"
{% end %} # Cairo::C::HAS_PS_SURFACE
