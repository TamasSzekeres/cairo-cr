require "./c/features"
require "./c/lib_cairo"

{% if Cairo::C::HAS_SVG_SURFACE %}

module Cairo
  include Cairo::C

  # `SvgVersion` is used to describe the version number of the
  # SVG specification that a generated SVG file will conform to.
  enum SvgVersion
    # The version 1.1 of the SVG specification.
    V_1_1

    # The version 1.2 of the SVG specification.
    V_1_2

    # Get the string representation of the given version id.
    # This function will return `nil` if version isn't valid.
    # See `SvgSurface#versions` for a way to get the list of valid version ids.
    #
    # ###Returns
    # The string associated to given version.
    def to_string : String
      String.new(LibCairo.svg_version_to_string(LibCairo::SvgVersionT.new(self.value)))
    end
  end
end

{% end %}
