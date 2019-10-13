require "./c/lib_cairo"
require "./rectangle"
require "./status"

module Cairo
  include Cairo::C

  # Wraper for LibCairo::RectangleListT
  class RectangleList
    include Indexable(Rectangle)

    def initialize(list : LibCairo::PRectangleListT)
      raise ArgumentError.new("'list' cannot be null") if list.null?
      @list = list
    end

    def finaize
      LibCairo.rectangle_list_destroy(@list)
    end

    def status : Status
      Status.new(@list.value.status.value)
    end

    @[AlwaysInline]
    def size
      @list.value.num_rectangles
    end

    @[AlwaysInline]
    def unsafe_fetch(index : Int)
      Rectangle.new(@list.value.rectangles[index])
    end

    def to_cairo_rectangle_list : LibCairo::RectangleListT
      @list.value
    end

    def to_unsafe : LibCairo::PRectangleListT
      @list
    end
  end
end
