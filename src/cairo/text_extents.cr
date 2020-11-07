require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # The `TextExtents` structure stores the extents of a single glyph or a string of glyphs in user-space coordinates.
  # Because text extents are in user-space coordinates, they are mostly, but not entirely,
  # independent of the current transformation matrix. If you call `context.scale(2.0, 2.0)`,
  # text will be drawn twice as big, but the reported text extents will not be doubled.
  # They will change slightly due to hinting (so you can't assume that metrics are independent of the transformation matrix),
  # but otherwise will remain unchanged.
  class TextExtents
    def initialize
      @text_extents = LibCairo::TextExtentsT.new
    end

    def initialize(x_bearing : Float64, y_bearing : Float64,
                   width : Float64, height : Float64,
                   x_advance : Float64, y_advance : Float64)
      @text_extents = LibCairo::TextExtentsT.new
      @text_extents.x_bearing = x_bearing
      @text_extents.y_bearing = y_bearing
      @text_extents.width = width
      @text_extents.height = height
      @text_extents.x_advance = x_advance
      @text_extents.y_advance = y_advance
    end

    def initialize(@text_extents : LibCairo::TextExtentsT)
    end

    # The horizontal distance from the origin to the leftmost part of the glyphs as drawn.
    # Positive if the glyphs lie entirely to the right of the origin.
    @[AlwaysInline]
    def x_bearing : Float64
      @text_extents.x_bearing
    end

    @[AlwaysInline]
    def x_bearing=(x_bearing : Float64)
      @text_extents.x_bearing = x_bearing
    end

    # The vertical distance from the origin to the topmost part of the glyphs as drawn.
    # Positive only if the glyphs lie completely below the origin; will usually be negative.
    @[AlwaysInline]
    def y_bearing : Float64
      @text_extents.y_bearing
    end

    @[AlwaysInline]
    def y_bearing=(y_bearing : Float64)
      @text_extents.y_bearing = y_bearing
    end

    # Width of the glyphs as drawn.
    @[AlwaysInline]
    def width : Float64
      @text_extents.width
    end

    @[AlwaysInline]
    def width=(width : Float64)
      @text_extents.width = width
    end

    # Height of the glyphs as drawn.
    @[AlwaysInline]
    def height : Float64
      @text_extents.height
    end

    @[AlwaysInline]
    def height=(height : Float64)
      @text_extents.height = height
    end

    # Distance to advance in the X direction after drawing these glyphs.
    @[AlwaysInline]
    def x_advance : Float64
      @text_extents.x_advance
    end

    @[AlwaysInline]
    def x_advance=(x_advance : Float64)
      @text_extents.x_advance = x_advance
    end

    # Distance to advance in the Y direction after drawing these glyphs.
    #
    # Will typically be zero except for vertical text layout as found in East-Asian languages.
    @[AlwaysInline]
    def y_advance : Float64
      @text_extents.y_advance
    end

    @[AlwaysInline]
    def y_advance=(y_advance : Float64)
      @text_extents.y_advance = y_advance
    end

    def to_cairo_text_extents : LibCairo::TextExtentsT
      @text_extents
    end

    def to_unsafe : LibCairo::PTextExtentsT
      pointerof(@text_extents)
    end
  end
end
