require "./c/lib_cairo"

module Cairo
  # Paths are the most basic drawing tools and are primarily used to implicitly generate simple masks.
  #
  # Path is a data structure for holding a path. This data structure serves as the return value for
  # `Context#copy_path˙ and `Context#copy_path_flat` as well the input value for `Context#append`.
  #
  # See `PathDataType` for hints on how to iterate over the actual data within the path.
  #
  # The num_data function gives the number of elements in the data array.
  # This number is larger than the number of independent path portions (defined in `PathDataType`),
  # since the data includes both headers and coordinates for each portion.
  class Path
    def initialize(path : LibCairo::PPathT)
      raise ArgumentError.new("'path' cannot be null.") if path.null?
      @path = path
    end

    # Immediately releases all memory associated with path.
    # After a call to `Path#finalize` the path pointer is no longer valid and should not be used further.
    #
    # NOTE: should only be called `Path` returned by a `Context` function.
    # Any path that is created manually (ie. outside of `Context`) should be destroyed manually as well.
    def finalize
      LibCairo.path_destroy(@path)
    end

    # Returns the current error status.
    def status : Status
      Status.new(@path.value.status.value)
    end

    def status=(status : Status)
      @path.value.status = LibCairo::StatusT.new(status.value)
    end

    def [](index : Int) : PathData
      PathData.new(@path.value.data[index])
    end

    # Returns the number of elements in the path.
    def num_data : Int32
      @path.value.num_data
    end

    def to_cairo_path : LibCairo::PathT
      @path.value
    end

    def to_unsafe : LibCairo::PPathT
      @path
    end
  end
end
