require "./c/features"
require "./c/lib_cairo"

{% if Cairo::C::HAS_SVG_SURFACE %}

module Cairo
  include Cairo::C

  # `SvgUnit` used to describe the units valid for coordinates and
  # lengths in the SVG specification.
  #
  # ###See also
  # - [https://www.w3.org/TR/SVG/coords.html#Units](https://www.w3.org/TR/SVG/coords.html#Units)
  # - [https://www.w3.org/TR/SVG/types.html#DataTypeLength](https://www.w3.org/TR/SVG/types.html#DataTypeLength)
  # - [https://www.w3.org/TR/css-values-3/#lengths](https://www.w3.org/TR/css-values-3/#lengths)
  enum SvgUnit
    # User unit, a value in the current coordinate system.
    # If used in the root element for the initial coordinate systems it
    # corresponds to pixels.
    User = 0

    # The size of the element's font.
    Em

    # The x-height of the element’s font.
    Ex

    # Pixels (1px = 1/96th of 1in).
    Px

    # Inches (1in = 2.54cm = 96px).
    In

    # Centimeters (1cm = 96px/2.54).
    Cm

    # Millimeters (1mm = 1/10th of 1cm).
    Mm

    # Points (1pt = 1/72th of 1in).
    Pt

    # Picas (1pc = 1/6th of 1in).
    Pc

    # Percent, a value that is some fraction of another reference value.
    Percent
  end
end

{% end %}
