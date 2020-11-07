require "./c/lib_cairo"
require "./glyph"

module Cairo
  include Cairo::C

  class GlyphArray
    include Indexable(Glyph)

    def initialize(num_glyphs : Int)
      @glyphs = LibCairo.glyph_allocate(num_glyphs)
      raise "Can't allocate glyphs." if @glyphs.null?
      @num_glyphs = num_glyphs
    end

    def initialize(glyphs : LibCairo::PGlyphT, num_glyphs : Int32)
      raise ArgumentError.new("'glyphs' cannot be null.") if glyphs.null?
      raise ArgumentError.new("'num_glyphs' must be positive.") unless num_glyphs > 0

      @glyphs = glyphs
      @num_glyphs = num_glyphs
    end

    def finalize
      LibCairo.glyph_free(@glyphs)
      @num_glyphs = 0
    end

    # :inherit:
    def size
      @num_glyphs
    end

    # :inherit:
    def unsafe_fetch(index : Int)
      (@glyphs + index).value
    end

    def []=(index : Int, glyph : Glyph)
      check_index_out_of_bounds index
      (@glyphs + index).value = glyph.to_unsafe.value
    end

    def to_unsafe : LibCairo::PGlyphT
      @glyphs
    end
  end
end
