require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # A data structure for holding a rectangle.
  #
  # Wrapper for `LibCairo::RectangleT` structure.
  struct Rectangle
    # Creates uninitialized rectangle.
    def initialize
      @rect = LibCairo::RectangleT.new
    end

    # Creates new rectangle using specified coordinates of top left corner (x, y), width and height.
    def initialize(x : Float64, y : Float64, width : Float64, height : Float64)
      @rect = LibCairo::RectangleT.new
      @rect.x = x
      @rect.y = y
      @rect.width = width
      @rect.height = height
    end

    # Creates new rectangle from `LibCairo::RectangleT`.
    def initialize(@rect : LibCairo::RectangleT)
    end

    # X coordinate of the left side of the rectangle.
    def x : Float64
      @rect.x
    end

    # Setter for X coordinate.
    def x=(x : Float64)
      @rect.x = x
    end

    # Y coordinate of the the top side of the rectangle.
    def y : Float64
      @rect.y
    end

    # Setter for Y coordinate.
    def y=(y : Float64)
      @rect.y = y
    end

    # Width of the rectangle.
    def width : Float64
      @rect.width
    end

    # Setter for width.
    def width=(width : Float64)
      @rect.width = width
    end

    # Height of the rectangle.
    def height : Float64
      @rect.height
    end

    # Setter for height.
    def height=(height : Float64)
      @rect.height = height
    end

    # Returns undelying `LibCairo::RectangleT` structure.
    def to_cairo_rectange : LibCairo::RectangleT
      @rect
    end

    # Pointer of underlying `LibCairo::RectangleT` structure.
    def to_unsafe : LibCairo::PRectangleT
      pointerof(@rect)
    end
  end
end
