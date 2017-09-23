require "./c/lib_cairo"

module Cairo
  include Cairo::C
  
  # Wrapper for LibCairo::RectangleT structure.
  struct Rectangle
    def initialize
      @rect = LibCairo::RectangleT.new
    end

    def initialize(x : Float64, y : Float64, width : Float64, height : Float64)
      @rect = LibCairo::RectangleT.new
      @rect.x = x
      @rect.y = y
      @rect.width = width
      @rect.height = height
    end

    def initialize(@rect : LibCairo::RectangleT)
    end

    def x : Float64
      @rect.x
    end

    def x=(x : Float64)
      @rect.x = x
    end

    def y : Float64
      @rect.y
    end

    def y=(y : Float64)
      @rect.y = y
    end

    def width : Float64
      @rect.width
    end

    def width=(width : Float64)
      @rect.width = width
    end

    def height : Float64
      @rect.height
    end

    def height=(height : Float64)
      @rect.height = height
    end

    def to_cairo_rectange : LibCairo::RectangleT
      @rect
    end

    def to_unsafe : LibCairo::PRectangleT
      pointerof(@rect)
    end
  end
end
