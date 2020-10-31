require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # A data structure for holding a rectangle.
  #
  # Wrapper for LibCairo::RectangleIntT
  struct RectangleInt
    # Creates uninitialized rectangle.
    def initialize
      @rect = LibCairo::RectangleIntT.new
    end

    # Creates new rectangle using specified coordinates of top left corner (x, y), width and height.
    def initialize(x : Int32, y : Int32, width : Int32, height : Int32)
      @rect = LibCairo::RectangleIntT.new
      @rect.x = x
      @rect.y = y
      @rect.width = width
      @rect.height = height
    end

    # Creates new rectangle from `LibCairo::RectangleT`.
    def initialize(@rect : LibCairo::RectangleIntT)
    end

    # X coordinate of the left side of the rectangle.
    def x : Int32
      @rect.x
    end

    # Setter for X coordinate.
    def x=(x : Int32)
      @rect.x = x
    end

    # Y coordinate of the the top side of the rectangle.
    def y : Int32
      @rect.y
    end

    # Setter for Y coordinate.
    def y=(y : Int32)
      @rect.y = y
    end

    # Width of the rectangle.
    def width : Int32
      @rect.width
    end

    # Setter for width.
    def width=(width : Int32)
      @rect.width = width
    end

    # Height of the rectangle.
    def height : Int32
      @rect.height
    end

    # Setter for height.
    def height=(height : Int32)
      @rect.height = height
    end

    # Returns undelying `LibCairo::RectangleIntT` structure.
    def to_cairo_rectangle : LibCairo::RectangleIntT
      @rect
    end

    # Pointer of underlying `LibCairo::RectangleIntT` structure.
    def to_unsafe : LibCairo::PRectangleIntT
      pointerof(@rect)
    end
  end
end
