require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # A `Region` represents a set of integer-aligned rectangles.
  #
  # It allows set-theoretical operations like `Region#union` and `Region#intersect` to be performed on them.
  #
  # Memory management of `Region` is done with `Region#reference` and `Region#finalize`.
  #
  # Wrapper for LibCairo::PRegionT
  class Region
    def initialize(region : LibCairo::PRegionT)
      raise ArgumentError.new("'region' cannot be null.") unless region.null?
      @region = region
    end

    # Allocates a new empty region object.
    def initialize
      @region = LibCairo.region_create
    end

    # Allocates a new region object containing rectangle.
    def initialize(rectangle : RectangleInt)
      @region = LibCairo.region_create_rectangle(rectangle.to_cairo_rectangle)
    end

    # Allocates a new region object containing the union of all given rects.
    #
    # ###Parameters
    # - **rects** an array of count rectangles
    def initialize(rects : Array(RectangleInt))
      @region = LibCairo.region_create_rectangles(
        rect.to_unsafe.as(LibCairo::PRectangleT), rects.size)
    end

    # Destroys a `Region` object created with `Region#initialize`, `Region#dup`, or `Region#initialize(rectangle)`.
    def finalize
      LibCairo.region_destroy(@region)
    end

    # Allocates a new region object copying the area from original.
    def dup : Region
      Region.new(LibCairo.region_copy(@region))
    end

    #Increases the reference count on region by one. This prevents region from being destroyed until a matching call
    # to `Region#finalize` is made.
    #
    # ###Returns
    # The referenced `Region`.
    def reference : Region
      Region.new(LibCairo.region_reference(@region))
    end

    # Compares whether region is equivalent to *other*.
    #
    # ###Parameters
    # - **other* a `Region` object
    #
    # ###Returns
    # `true` if both regions contained the same coverage, `false` if it is not or any region is in an error status.
    def ==(other : Region) : Bool
      LibCairo.region_equal(@region, other.to_unsafe) == 1
    end

    # Checks whether an error has previous occurred for this region object.
    #
    # ###Returns
    # `Status::Success` or `Status::NoMemory`
    def status : Status
      Status.new(LibCairo.region_status(@region).value)
    end

    # Gets the bounding rectangle of region as a `RectangleInt`.
    #
    # ###Parameters
    # - **extents** rectangle into which to store the extents
    def extents : RectangleInt
      LibCairo.region_get_extents(@region, out extents)
      RectangleInt.new(extents)
    end

    # Returns the number of rectangles contained in region.
    #
    # ###Returns
    # The number of rectangles contained in region.
    def num_rectangles : Int32
      LibCairo.region_num_rectangles(@region)
    end

    # Stores the nth rectangle from the region in rectangle.
    #
    # ###Parameters
    # - **nth** a number indicating which rectangle should be returned
    #
    # ###Returns
    # The location for a `RectangleInt`.
    def rectangle(nth : Int32) : RectangleInt
      LibCairo.region_get_rectangle(@region, nth, out rectangle)
      RectangleInt.new(rectangle)
    end

    # Checks whether region is empty.
    #
    # ###Returns
    # `true` if region is empty, `false` if it isn't.
    def empty? : Bool
      LibCairo.region_is_empty(@region) == 1
    end

    # Checks whether rectangle is inside, outside or partially contained in region.
    #
    # ###Parameters
    # - **rectangle** a `RectangleInt`
    #
    # ###Returns
    # - `RegionOverlap::In` if rectangle is entirely inside region
    # - `RegionOverlap::Out` if rectangle is entirely outside region
    # - `RegionOVerlap::Part` if rectangle is partially inside and partially outside region
    def contains?(rectangle : RectangleInt) : RegionOverlap
      RegionOverlap.new(LibCairo.region_contains_rectangle(@region, rectangle.to_unsafe).value)
    end

    # Checks whether *(x, y)* is contained in region.
    #
    # ###Parameters
    # - *x* the x coordinate of a point
    # - *y* the y coordinate of a point
    #
    # ###Returns
    # `true` if *(x, y)* is contained in region, `false` if it is not.
    def contains?(x : Int32, y : Int32) : Bool
      LibCairo.region_contains_point(@region, x, y) == 1
    end

    def contains?(p : Point) : Bool
      LibCairo.region_contains_point(@region, p.x, p.y) == 1
    end

    # Translates region by *(dx, dy)*.
    #
    # ###Parameters
    # - **dx** Amount to translate in the x direction
    # - **dy** Amount to translate in the y direction
    def translate(dx : Int32, dy : Int32)
      LibCairo.region_translate(@region, dx, dy)
      self
    end

    def translate(d : Point)
      LibCairo.region_translate(@region, d.x, d.y)
      self
    end

    # Subtracts other from `self` and places the result in `self`.
    #
    # ###Parameters
    # - **other** another `Region`
    #
    # ###Raises
    # `StatusException` with status of `Status::NoMemory`.
    def subtract(other : Region)
      status = Status.new(LibCairo.region_subtract(@region, other.to_unsafe).value)
      raise new StatusException.new(status) unless status.success?
      self
    end

    # Subtracts rectangle from `self` and places the result in `self`.
    #
    # ###Parameters
    # - **rectangle** a `RectangleInt`
    #
    # ###Raises
    # `StatusException` with status of `Status::NoMemory`.
    def subtract(rectangle : RectangleInt)
      status = Status.new(LibCairo.region_subtract_rectangle(@region, rectangle.to_unsafe).value)
      raise new StatusException.new(status) unless status.success?
      self
    end

    # Computes the intersection of `self` with other and places the result in `self`.
    #
    # ###Parameters
    # - **other** another `Region`
    #
    # ##Raises
    # `StatusException` with status of `Status::NoMemory`.
    def intersect(other : Region)
      status = Status.new(LibCairo.region_intersect(@region, other.to_unsafe).value)
      raise new StatusException.new(status) unless status.success?
      self
    end

    # Computes the intersection of `self` with rectangle and places the result in `self`.
    #
    # ###Parameters
    # - **rectangle** a `RectangleInt`
    #
    # ###Raises
    # `StatusException` with status of `Status::NoMemory`.
    def intersect(rectangle : RectangleInt)
      status = Status.new(LibCairo.region_intersect_rectangle(@region, rectangle.to_unsafe).value)
      raise new StatusException.new(status) unless status.success?
      self
    end

    # Computes the union of `self` with other and places the result in `self`.
    #
    # ###Parameters
    # - **other** another `Region`
    #
    # ###Raises
    # `StatusException` with status of `Status::NoMemory`.
    def union(other : Region)
      status = Status.new(LibCairo.region_union(@region, other.to_unsafe).value)
      raise new StatusException.new(status) unless status.success?
      self
    end

    # Computes the union of `self` with rectangle and places the result in `self`.
    #
    # ###Parameters
    # - **rectangle** a RectangleInt
    #
    # ###Raises
    # `StatusException` with status of `Status::NoMemory`.
    def union(rectangle : RectangleInt)
      status = Status.new(LibCairo.region_union_rectangle(@region, rectangle.to_unsafe).value)
      raise new StatusException.new(status) unless status.success?
      self
    end

    # Computes the exclusive difference of `self` with other and places the result in `self`.
    # That is, `self` will be set to contain all areas that are either in `self` or in other , but not in both.
    #
    # ###Parameters
    # - **other** another `Region`
    #
    # ###Raises
    # `StatusException` with status of `Status::NoMemory`.
    def xor(other : Region)
      status = Status.new(LibCairo.region_xor(@region, other.to_unsafe).value)
      raise new StatusException.new(status) unless status.success?
      self
    end

    # Computes the exclusive difference of `self` with rectangle and places the result in `self`.
    # That is, `self` will be set to contain all areas that are either in `self` or in rectangle, but not in both.
    #
    # ###Parameters
    # - **rectangle** a `RectangleInt`
    #
    # ###Raises
    # `StatusException` with status of `Status::NoMemory`.
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
