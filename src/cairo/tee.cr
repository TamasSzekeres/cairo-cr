require "./cairo"

{% if CairoCr::HAS_TEE_SURFACE %}
  module CairoCr
    @[Link("cairo")]
    lib Cairo
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
    end # lib Cairo
  end # module CairoCr
{% else %} # CairoCr::HAS_TEE_SURFACE
  puts "Cairo was not compiled with support for the TEE backend"
{% end %} # CairoCr::HAS_TEE_SURFACE
