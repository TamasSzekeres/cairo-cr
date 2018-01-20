require "./lib_cairo"
require "./features"

{% if Cairo::C::HAS_PDF_SURFACE %}
  module Cairo::C
    @[Link("cairo")]
    lib LibCairo
      enum PdfVersionT
        V_1_4,
        V_1_5
      end

      fun pdf_surface_create = cairo_pdf_surface_create(
        filename : UInt8*,
        width_in_points : Float64,
        height_in_points : Float64
      ) : PSurfaceT

      fun pdf_surface_create_for_stream = cairo_pdf_surface_create_for_stream(
        write_func : WriteFuncT,
        closure : Void*,
        width_in_points : Float64,
        height_in_points : Float64
      ) : PSurfaceT

      fun pdf_surface_restrict_to_version = cairo_pdf_surface_restrict_to_version(
        surface : PSurfaceT,
        version : PdfVersionT
      ) : Void

      fun pdf_get_versions = cairo_pdf_get_versions(
        versions : PdfVersionT**,
        num_versions : Int32*
      ) : Void

      fun pdf_version_to_string = cairo_pdf_version_to_string(
        version : PdfVersionT
      ) : UInt8*

      fun pdf_surface_set_size = cairo_pdf_surface_set_size(
        surface : PSurfaceT,
        width_in_points : Float64,
        height_in_points : Float64
      ) : Void
    end # lib LibCairo
  end # module Cairo::C
{% else %} # Cairo::C::HAS_PDF_SURFACE
  puts "Cairo was not compiled with support for the pdf backend"
{% end %} # Cairo::C::HAS_PDF_SURFACE
