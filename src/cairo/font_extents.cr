require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # Wrapper for LibCairo::FontExtentsT
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

    @[AlwaysInline]
    def ascent : Float64
      @font_extents.ascent
    end

    @[AlwaysInline]
    def ascent=(ascent : Float64)
      @font_extents.ascent = ascent
    end

    @[AlwaysInline]
    def descent : Float64
      @font_extents.descent
    end

    @[AlwaysInline]
    def descent=(descent : Float64)
      @font_extents.descent = descent
    end

    @[AlwaysInline]
    def height : Float64
      @font_extents.height
    end

    @[AlwaysInline]
    def height=(height : Float64)
      @font_extents.height = height
    end

    @[AlwaysInline]
    def max_x_advance : Float64
      @font_extents.max_x_advance
    end

    @[AlwaysInline]
    def max_x_advance=(max_x_advance : Float64)
      @font_extents.max_x_advance = max_x_advance
    end

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
