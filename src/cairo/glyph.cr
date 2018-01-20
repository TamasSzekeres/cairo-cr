require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # Wrapper for LibCairo::PGlyphT.
  class Gylph
    def initialize
      @glyph = LibCairo.glyph_allocate(1)
      raise "Can't allocate glyph." if @glyph.null?
    end

    def initialize(glyph : LibCairo::PGlyphT)
      raise ArgumentError.new("'glyph' cannot be null.") if glyph.null?
      @glyph = glyph
    end

    def finalize
      LibCairo.glyph_free(@gylph)
    end

    def to_unsafe : LibCairo::PGlyphT
      @glyph
    end
  end
end
