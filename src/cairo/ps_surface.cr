require "./c/features"
require "./c/lib_cairo"
require "./c/ps"

{% if Cairo::C::HAS_PS_SURFACE %}

module Cairo
  include Cairo::C
  
  class PsSurface < Surface
    def initialize(filename : String, width_in_points : Float64, height_in_points : Float64)
      super(LibCairo.ps_surface_create(filename.to_unsafe, width_in_points, height_in_points))
    end

    def initialize(write_func : LibCairo::WriteFuncT, closure : Void*, width_in_points : Float64, height_in_points : Float64)
      super(LibCairo.ps_surface_create_for_stream(write_func, closure, width_in_points, height_in_points))
    end

    def ps_surface_restrict_to_level(level : PsLevel)
      LibCairo.ps_surface_restrict_to_level(to_unsafe, LibCairo::PsLevelT.new(level.value))
      self
    end

    def self.levels : Array(PsLevel)
      LibCairo.ps_get_levels(out levels, out num_levels)
      return [] of PsLevel if num_levels == 0
      Array(PsLevel).new(num_levels) do |i|
        PsLevel.new(levels[i].value)
      end
    end

    def eps : Bool
      LibCairo.ps_surface_get_eps(to_unsafe) == 1
    end

    def eps=(eps : Bool)
      LibCairo.ps_surface_set_eps(to_unsafe, eps ? 1 : 0)
      self
    end

    def set_size(width_in_points : Float64, height_in_points : Float64)
      LibCairo.ps_surface_set_size(to_unsafe, width_in_points, height_in_points)
      self
    end

    def dsc_comment(comment : String)
      LibCairo.ps_surface_dsc_comment(to_unsafe, comment.to_unsafe)
      self
    end

    def dsc_begin_setup
      LibCairo.ps_surface_dsc_begin_setup(to_unsafe)
      self
    end

    def dsc_begin_page_setup
      LibCairo.ps_surface_dsc_begin_page_setup(to_unsafe)
      self
    end
  end
end

{% end %}
