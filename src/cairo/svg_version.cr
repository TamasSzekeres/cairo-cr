require "./c/features"
require "./c/lib_cairo"

{% if Cairo::C::HAS_SVG_SURFACE %}

module Cairo
  include Cairo::C

  enum SvgVersion
    V_1_1,
    V_1_2

    def to_string : String
      String.new(LibCairo.svg_version_to_string(LibCairo::SvgVersionT.new(self.value)))
    end
  end
end

{% end %}
