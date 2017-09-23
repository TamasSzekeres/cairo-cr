require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # Wrapper for LibCairo::TextExtentsT
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

    @[AlwaysInline]
    def x_bearing : Float64
      @text_extents.x_bearing
    end

    @[AlwaysInline]
    def x_bearing=(x_bearing : Float64)
      @text_extents.x_bearing = x_bearing
    end

    @[AlwaysInline]
    def y_bearing : Float64
      @text_extents.y_bearing
    end

    @[AlwaysInline]
    def y_bearing=(y_bearing : Float64)
      @text_extents.y_bearing = y_bearing
    end

    @[AlwaysInline]
    def width : Float64
      @text_extents.width
    end

    @[AlwaysInline]
    def width=(width : Float64)
      @text_extents.width = width
    end

    @[AlwaysInline]
    def height : Float64
      @text_extents.height
    end

    @[AlwaysInline]
    def height=(height : Float64)
      @text_extents.height = height
    end

    @[AlwaysInline]
    def x_advance : Float64
      @text_extents.x_advance
    end

    @[AlwaysInline]
    def x_advance=(x_advance : Float64)
      @text_extents.x_advance = x_advance
    end

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
