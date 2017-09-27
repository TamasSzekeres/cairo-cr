require "./lib_cairo"
require "./features"

{% if Cairo::C::HAS_TEE_SURFACE %}
  module Cairo::C
    @[Link("cairo")]
    lib LibCairo
      fun tee_surface_create = cairo_tee_surface_create(
        master : PSurfaceT
      ) : PSurfaceT

      fun tee_surface_add = cairo_tee_surface_add(
        surface : PSurfaceT,
        target : PSurfaceT
      ) : Void

      fun tee_surface_remove = cairo_tee_surface_remove(
        surface : PSurfaceT,
        target : PSurfaceT
      ) : Void

      fun tee_surface_index = cairo_tee_surface_index(
        surface : PSurfaceT,
        index : UInt32
      ) : PSurfaceT
    end # lib LibCairo
  end # module Cairo::C
{% else %} # Cairo::C::HAS_TEE_SURFACE
  puts "Cairo was not compiled with support for the TEE backend"
{% end %} # Cairo::C::HAS_TEE_SURFACE
