require "./c/lib_cairo"

module Cairo
  class Path
    def initialize(path : LibCairo::PPathT)
      raise ArgumentError.new("'path' cannot be null.") if path.null?
      @path = path
    end

    def finalize
      LibCairo.path_destroy(@path)
    end

    def status : Status
      Status.new(@path.value.status.value)
    end

    def status=(status : Status)
      @path.value.status = LibCairo::StatusT.new(status.value)
    end

    def [](index : Int) : PathData
      PathData.new(@path.value.data[index])
    end

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
