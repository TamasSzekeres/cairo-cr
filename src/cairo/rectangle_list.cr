require "./c/lib_cairo"
require "./rectangle"
require "./status"

module Cairo
  include Cairo::C

  # A data structure for holding a dynamically allocated array of rectangles.
  #
  # Wraper for LibCairo::RectangleListT
  class RectangleList
    include Indexable(Rectangle)

    def initialize(list : LibCairo::PRectangleListT)
      raise ArgumentError.new("'list' cannot be null") if list.null?
      @list = list
    end

    def finalize
      LibCairo.rectangle_list_destroy(@list)
    end

    # Error status of the rectangle list
    def status : Status
      Status.new(@list.value.status.value)
    end

    # Number of rectangles in this list
    @[AlwaysInline]
    def size : Int32
      @list.value.num_rectangles
    end

    # Returns rectangle at the given index.
    @[AlwaysInline]
    def unsafe_fetch(index : Int) : Rectangle
      Rectangle.new(@list.value.rectangles[index])
    end

  # Returns undelying `LibCairo::RectangleIntT` structure.
    def to_cairo_rectangle_list : LibCairo::RectangleListT
      @list.value
    end

    # Pointer of list.
    def to_unsafe : LibCairo::PRectangleListT
      @list
    end
  end
end
