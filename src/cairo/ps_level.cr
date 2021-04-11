require "./c/features"
require "./c/lib_cairo"
require "./c/ps"

{% if Cairo::C::HAS_PS_SURFACE %}

module Cairo
  # Describes the language level of the PostScript Language Reference
  # that a generated PostScript file will conform to.
  enum PsLevel
    # The language level 2 of the PostScript specification.
    Level2

    # The language level 3 of the PostScript specification.
    Level3

    # Get the string representation of the given level id.
    # This function will return empty string if level id isn't valid.
    # See `PsSurface#levels` for a way to get the list of valid level ids.
    #
    # ###Returns
    # The string associated to given level.
    def to_string : String
      String.new(LibCairo.ps_level_to_string(LibCairo::PsLevelT.new(self)))
    end
  end
end

{% end %}
