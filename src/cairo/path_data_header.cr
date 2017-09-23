require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # Wrapper for LibCairo::PathDataHeaderT
  struct PathDataHeader
    def initialize
      @header = PathDataHeaderT.new
    end

    def initialize(type : PathDataType, length : Int32)
      @header = PathDataHeaderT.new
      @header.type = PathDataHeaderT.new(type.value)
      @header.length = length
    end

    def initialize(@header : LibCairo::PathDataHeaderT)
    end

    def type : PathDataType
      PathDataType.new(@header.type.value)
    end

    def type=(type : PathDataType)
      @header.type = LibCairo::PathDataType.new(type.value)
    end

    def length : Int32
      @header.length
    end

    def length=(length : Int32)
      @header.length = length
    end

    def to_cairo_path_data_header : LibCairo::PathDataHeaderT
      @header
    end

    def to_unsafe : LibCairo::PPathDataHeaderT
      pointerof(@header)
    end
  end
end
