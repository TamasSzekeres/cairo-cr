require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # The `FontExtents` structure stores metric information for a font.
  # Values are given in the current user-space coordinate system.
  #
  # Because font metrics are in user-space coordinates, they are mostly,
  # but not entirely, independent of the current transformation matrix.
  # If you call `context.scale(2.0, 2.0)`, text will be drawn twice as big,
  # but the reported text extents will not be doubled. They will change slightly due
  # to hinting (so you can't assume that metrics are independent of the transformation matrix),
  # but otherwise will remain unchanged.
  class FontExtents
    def initialize
      @font_extents = LibCairo::FontExtentsT.new
    end

    def initialize(ascent : Float64, descent : Float64, height : Float64,
                   max_x_advance : Float64, max_y_advance : Float64)
      @font_extents = LibCairo::FontExtentsT.new
      @font_extents.ascent = ascent
      @font_extents.descent = descent
      @font_extents.height = height
      @font_extents.max_x_advance = max_x_advance
      @font_extents.max_y_advance = max_y_advance
    end

    def initialize(@font_extents : LibCairo::FontExtentsT)
    end

    # The distance that the font extends above the baseline.
    #
    # NOTE that this is not always exactly equal to the maximum of the extents of all the glyphs in the font,
    # but rather is picked to express the font designer's intent as to how the font should align with elements above it.
    @[AlwaysInline]
    def ascent : Float64
      @font_extents.ascent
    end

    @[AlwaysInline]
    def ascent=(ascent : Float64)
      @font_extents.ascent = ascent
    end

    # The distance that the font extends below the baseline.
    #
    # This value is positive for typical fonts that include portions below the baseline.
    # NOTE that this is not always exactly equal to the maximum of the extents of all the glyphs in the font,
    # but rather is picked to express the font designer's intent as to how the font should align with elements below it.
    @[AlwaysInline]
    def descent : Float64
      @font_extents.descent
    end

    @[AlwaysInline]
    def descent=(descent : Float64)
      @font_extents.descent = descent
    end

    # The recommended vertical distance between baselines when setting consecutive lines of text with the font.
    #
    # This is greater than *ascent+descent* by a quantity known as the line spacing or external leading.
    # When space is at a premium, most fonts can be set with only a distance of *ascent+descent* between lines.
    @[AlwaysInline]
    def height : Float64
      @font_extents.height
    end

    @[AlwaysInline]
    def height=(height : Float64)
      @font_extents.height = height
    end

    # The maximum distance in the X direction that the origin is advanced for any glyph in the font.
    @[AlwaysInline]
    def max_x_advance : Float64
      @font_extents.max_x_advance
    end

    @[AlwaysInline]
    def max_x_advance=(max_x_advance : Float64)
      @font_extents.max_x_advance = max_x_advance
    end

    # The maximum distance in the Y direction that the origin is advanced for any glyph in the font.
    #
    # This will be zero for normal fonts used for horizontal writing. (The scripts of East Asia are sometimes written vertically.)
    @[AlwaysInline]
    def max_y_advance : Float64
      @font_extents.max_y_advance
    end

    @[AlwaysInline]
    def max_y_advance=(max_y_advance : Float64)
      @font_extents.max_y_advance = max_y_advance
    end

    def to_cairo_font_extents : LibCairo::FontExtentsT
      @font_extents
    end

    def to_unsafe : LibCairo::PFontExtentsT
      pointerof(@font_extents)
    end
  end
end
