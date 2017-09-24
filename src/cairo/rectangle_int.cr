require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # Wrapper for LibCairo::RectangleIntT
  struct RectangleInt
    def initialize
      @rect = LibCairo::RectangleIntT.new
    end

    def initialize(x : Int32, y : Int32, width : Int32, height : Int32)
      @rect = LibCairo::RectangleIntT.new
      @rect.x = x
      @rect.y = y
      @rect.width = width
      @rect.height = height
    end

    def initialize(@rect : LibCairo::RectangleIntT)
    end

    def x
      @rect.x
    end

    def x=(x: Int32)
      @rect.x = x
    end

    def y
      @rect.y
    end

    def y=(y: Int32)
      @rect.y = y
    end

    def width
      @rect.width
    end

    def width=(width: Int32)
      @rect.width = width
    end

    def height
      @rect.height
    end

    def height=(height: Int32)
      @rect.height = height
    end

    def to_cairo_rectangle : LibCairo::RectangleIntT
      @rect
    end

    def to_unsafe : LibCairo::PRectangleIntT
      pointerof(@rect)
    end
  end
end
