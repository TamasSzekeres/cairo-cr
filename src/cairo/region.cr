require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # Wrapper for LibCairo::PRegionT
  class Region
    def initialize(region : LibCairo::PRegionT)
      raise ArgumentError.new("'region' cannot be null.") unless region.null?
      @region = region
    end

    def initialize
      @region = LibCairo.region_create
    end

    # Create Rectangle
    def initialize(rectangle : RectangleInt)
      @region = LibCairo.region_create_rectangle(rectangle.to_cairo_rectangle)
    end

    # Create Rectangles
    def initialize(rects : Array(RectangleInt))
      @region = LibCairo.region_create_rectangles(
        rect.to_unsafe.as(LibCairo::PRectangleT), rects.size)
    end

    def finalize
      LibCairo.region_destroy(@region)
    end

    def dup : Region
      Region.new(LibCairo.region_copy(@region))
    end

    def reference : Region
      Region.new(LibCairo.region_reference(@region))
    end

    def ==(other : Region) : Bool
      LibCairo.region_equal(@region, other.to_unsafe) == 1
    end

    def status : Status
      Status.new(LibCairo.region_status(@region).value)
    end

    def extents : RectangleInt
      LibCairo.region_get_extents(@region, out extents)
      RectangleInt.new(extents)
    end

    def num_rectangles : Int32
      LibCairo.region_num_rectangles(@region)
    end

    def rectangle(nth : Int32) : RectangleInt
      LibCairo.region_get_rectangle(@region, nth, out rectangle)
      RectangleInt.new(rectangle)
    end

    def empty? : Bool
      LibCairo.region_is_empty(@region) == 1
    end

    def contains?(rectangle : RectangleInt) : RegionOverlap
      RegionOverlap.new(LibCairo.region_contains_rectangle(@region, rectangle.to_unsafe).value)
    end

    def contains?(x : Int32, y : Int32) : Bool
      LibCairo.region_contains_point(@region, x, y) == 1
    end

    def contains?(p : Point) : Bool
      LibCairo.region_contains_point(@region, p.x, p.y) == 1
    end

    def translate(dx : Int32, dy : Int32)
      LibCairo.region_translate(@region, dx, dy)
      self
    end

    def translate(d : Point)
      LibCairo.region_translate(@region, d.x, d.y)
      self
    end

    def subtract(other : Region)
      status = Status.new(LibCairo.region_subtract(@region, other.to_unsafe).value)
      raise new StatusException.new(status) unless status.success?
      self
    end

    def subtract(rectangle : RectangleInt)
      status = Status.new(LibCairo.region_subtract_rectangle(@region, rectangle.to_unsafe).value)
      raise new StatusException.new(status) unless status.success?
      self
    end

    def intersect(other : Region)
      status = Status.new(LibCairo.region_intersect(@region, other.to_unsafe).value)
      raise new StatusException.new(status) unless status.success?
      self
    end

    def intersect(rectangle : RectangleInt)
      status = Status.new(LibCairo.region_intersect_rectangle(@region, rectangle.to_unsafe).value)
      raise new StatusException.new(status) unless status.success?
      self
    end

    def union(other : Region)
      status = Status.new(LibCairo.region_union(@region, other.to_unsafe).value)
      raise new StatusException.new(status) unless status.success?
      self
    end

    def union(rectangle : RectangleInt)
      status = Status.new(LibCairo.region_union_rectangle(@region, rectangle.to_unsafe).value)
      raise new StatusException.new(status) unless status.success?
      self
    end

    def xor(other : Region)
      status = Status.new(LibCairo.region_xor(@region, other.to_unsafe).value)
      raise new StatusException.new(status) unless status.success?
      self
    end

    def xor_rectangle(rectangle : RectangleInt)
      status = Status.new(LibCairo.region_xor_rectangle(@region, rectangle.to_unsafe).value)
      raise new StatusException.new(status) unless status.success?
      self
    end

    def to_unsafe : LibCairo::PRegionT
      @region
    end
  end
end
