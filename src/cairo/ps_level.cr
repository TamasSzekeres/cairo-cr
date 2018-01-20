require "./c/features"
require "./c/lib_cairo"
require "./c/ps"

{% if Cairo::C::HAS_PS_SURFACE %}

module Cairo
  enum PsLevel
    Level2,
    Level3

    def to_string : String
      String.new(LibCairo.ps_level_to_string(LibCairo::PsLevelT.new(self)))
    end
  end
end

{% end %}
