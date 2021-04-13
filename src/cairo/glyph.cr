require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # The `Glyph` structure holds information about a single glyph when drawing
  # or measuring text. A font is (in simple terms) a collection of shapes used
  # to draw text. A glyph is one of these shapes. There can be multiple glyphs
  # for a single character (alternates to be used in different contexts, for
  # example), or a glyph can be a *ligature* of multiple characters. Cairo
  # doesn't expose any way of converting input text into glyphs, so in order
  # to use the Cairo interfaces that take arrays of glyphs, you must directly
  # access the appropriate underlying font system.
  #
  # NOTE: that the offsets given by *x* and *y* are not cumulative.
  # When drawing or measuring text,
  # each glyph is individually positioned with respect to the overall origin.
  struct Glyph
    def initialize
      @glyph = uninitialized LibCairo::GlyphT
      @glyph.index = 0_u64
      @glyph.x = 0.0
      @glyph.y = 0.0
    end

    def initialize(index : UInt64, x : Float64, y : Float64)
      @glyph = uninitialized LibCairo::GlyphT
      @glyph.index = index
      @glyph.x = x
      @glyph.y = y
    end

    def initialize(@glyph : LibCairo::GlyphT)
    end

    def initialize(glyph : LibCairo::PGlyphT)
      raise ArgumentError.new("'glyph' cannot be null.") if glyph.null?
      @glyph = glyph.value
    end

    # Glyph index in the font. The exact interpretation of the glyph index depends on the font technology being used.
    def index : UInt64
      @glyph.index
    end

    def index=(index : UInt64)
      @glyph.index = index
    end

    # The offset in the X direction between the origin used for drawing or measuring the string and the origin of this glyph.
    def x : Float64
      @glyph.x
    end

    def x=(x : Float64)
      @glyph.x = x
    end

    # The offset in the Y direction between the origin used for drawing or measuring the string and the origin of this glyph.
    def y : Float64
      @glyph.y
    end

    def y=(y : Float64)
      @glyph.y = y
    end

    def to_cairo_glyph : LibCairo::GlyphT
      @glyph
    end

    def to_unsafe : LibCairo::PGlyphT
      pointerof(@glyph)
    end
  end
end
