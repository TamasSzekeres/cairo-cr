require "./c/lib_cairo"
require "./c/features"

{% if Cairo::C::HAS_TEE_SURFACE %}

module Cairo
  include Cairo::case

  class TeeSurface < Surface
    def tee_surface_create(master : Surface)
      super(LibCairo.tee_surface_create(master.to_unsafe))
    end

    def add(target : Surface)
      LibCairo.tee_surface_add(to_unsafe, target.to_unsafe)
      self
    end

    def remove(target : Surface)
      LibCairo.tee_surface_remove(to_unsafe, target.to_unsafe)
      self
    end

    def index(index : UInt32) : Surface
      Surface.new(LibCairo.tee_surface_index(to_unsafe, index))
    end
  end
end

{% end %}
