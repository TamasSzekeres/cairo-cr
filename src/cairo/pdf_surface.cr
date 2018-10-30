require "./c/features"
require "./c/lib_cairo"
require "./c/pdf"
require "./surface"

{% if Cairo::C::HAS_PDF_SURFACE %}

module Cairo
  include Cairo::C

  class PdfSurface < Surface
    def initialize(filename : String, width_in_points : Float64, height_in_points : Float64)
      super(LibCairo.pdf_surface_create(filename.to_unsafe, width_in_points, height_in_points))
    end

    def initialize(write_func : LibCairo::WriteFuncT, closure : Void*, width_in_points : Float64, height_in_points : Float64)
      super(LibCairo.pdf_surface_create_for_stream(write_func, closure, width_in_points, height_in_points))
    end

    def restrict_to_version(version : PdfVersion)
      LibCairo.pdf_surface_restrict_to_version(to_unsafe, LibCairo::PdfVersionT.new(version.value))
      self
    end

    def self.versions : Array(PdfVersion)
      LibCairo.pdf_get_versions(out version, out num_versions)
      return [] of PdfVersion if num_versions == 0
      Array(PdfVersion).new(num_versions) do |i|
        PdfVersion.new(version[i].value)
      end
    end

    def set_size(width_in_points : Float64, height_in_points : Float64)
      LibCairo.pdf_surface_set_size(to_unsafe, width_in_points, height_in_points)
      self
    end
  end
end

{% end %}
