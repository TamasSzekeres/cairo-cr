require "./c/features"
require "./c/lib_cairo"

{% if Cairo::C::HAS_SVG_SURFACE %}

module Cairo
  include Cairo::C

  class SvgSurface < Surface
    def initialize(filename : String, width_in_points : Float64, height_in_points : Float64)
      super(LibCairo.svg_surface_create(filename.to_unsafe, width_in_points, height_in_points))
    end

    # Create for Stream
    def initialize(write_func : LibCairo::WriteFuncT, closure : Void*, width_in_points : Float64, height_in_points : Float64)
      super(LibCairo.svg_surface_create_for_stream(write_func, closure, width_in_points, height_in_points))
    end

    def restrict_to_version(version : SvgVersion)
      LibCairo.svg_surface_restrict_to_version(to_unsafe, LibCairo::SvgVersionT.new(version.value))
      self
    end

    def self.versions : Array(SvgVersion)
      LibCairo.svg_get_versions(out, version, out num_versions)
      return [] of SvgVersion if num_versions == 0
      Array(SvgVersion).new(num_versions) do |i|
        SvgVersion.new(version[i].value)
      end
    end
  end
end

{% end %}
