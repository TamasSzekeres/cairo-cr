require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # Wrapper for LibCairo::PathDataT
  struct PathData
    def initialize(header : PathDataHeader)
      @data = LibCairo::PathDataT.new
      @data.header = header.to_cairo_path_data_header
    end

    def initialize(point : Point)
      @data = LibCairo::PathDataT.new
      @data.point = point.to_path_data_point
    end

    def initialize(@data : LibCairo::PPathDataT)
    end

    def header : PathDataHeader
      PathDataHeader.new(@data.header)
    end

    def header=(header : PathDataHeader)
      @data.header = header.to_cairo_path_data_header
    end

    def point : Point
      Point.new(@data.point)
    end

    def point=(point : Point)
      @data.point = point.to_path_data_point
    end

    def to_cairo_path_data : LibCairo::PathDataT
      @data
    end

    def to_unsafe : LibCairo::PPathDataT
      pointerof(@data)
    end
  end
end
