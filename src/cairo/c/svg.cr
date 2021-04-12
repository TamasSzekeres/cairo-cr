require "./lib_cairo"
require "./features"

{% if Cairo::C::HAS_SVG_SURFACE %}
  module Cairo::C
    @[Link("cairo")]
    lib LibCairo
      enum SvgVersionT
        V_1_1
        V_1_2
      end

      enum SvgUnitT
        User = 0
        Em
        Ex
        Px
        In
        Cm
        Mm
        Pt
        Pc
        Percent
      end

      fun svg_surface_create = cairo_svg_surface_create(
        filename : UInt8*,
        width_in_points : Float64,
        height_in_points : Float64
      ) : PSurfaceT

      fun svg_surface_create_for_stream = cairo_svg_surface_create_for_stream(
        write_func : WriteFuncT,
        closure : Void*,
        width_in_points : Float64,
        height_in_points : Float64
      ) : PSurfaceT

      fun svg_surface_restrict_to_version = cairo_svg_surface_restrict_to_version(
        surface : PSurfaceT,
        version : SvgVersionT
      ) : Void

      fun svg_get_versions = cairo_svg_get_versions(
        versions : SvgVersionT**,
        num_versions : Int32*
      ) : Void

      fun svg_version_to_string = cairo_svg_version_to_string(
        version : SvgVersionT
      ) : UInt8*

      fun svg_surface_set_document_unit = cairo_svg_surface_set_document_unit(
        surface : PSurfaceT,
        unit : SvgUnitT
      ) : Void

      fun svg_surface_get_document_unit = cairo_svg_surface_get_document_unit(
        surface : PSurfaceT
      ) : SvgUnitT
    end # lib LibCairo
  end # module Cairo::C
{% else %} # Cairo::C::HAS_SVG_SURFACE
  puts "Cairo was not compiled with support for the svg backend"
{% end %} # Cairo::C::HAS_SVG_SURFACE
