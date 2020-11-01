require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # Wrapper for LibCairo::PathDataT
  #
  # `PathData` is used to represent the path data inside a `Path`.
  #
  # The data structure is designed to try to balance the demands of efficiency and ease-of-use.
  # A path is represented as an array of `PathData`, which is a union of headers and points.
  #
  # Each portion of the path is represented by one or more elements in the array, (one header followed by 0 or more points).
  # The length value of the header is the number of array elements for the current portion including the header,
  # (ie. length == 1 + # of points), and where the number of points for each element type is as follows:
  # - `PathDataType::MoveTo`:     1 point
  # - `PathDataType::LineTo`:     1 point
  # - `PathDataType::CurveTo`:    3 points
  # - `PathDataType::ClosePath`:  0 points
  #
  # The semantics and ordering of the coordinate values are consistent with `Context#move_to`,
  # `Context#line_to`, `Context#curve_to`, and `Context#close_path`.
  #
  # Here is sample code for iterating through a `Path`:
  # ```
  # i = 0
  # path = ctx.copy_path
  # while i < path.num_data
  #   data = path[i]
  #   case data.header.type
  #   when PathDataType::MoveTo
  #       data1 = path[i + 1]
  #       printf("MoveTo(%5.2f, %5.2f)\n", data1.point.x, data1.point.y)
  #   when PathDataType::LineTo
  #       data1 = path[i + 1]
  #       printf("LineTo(%5.2f, %5.2f)\n", data1.point.x, data1.point.y)
  #   when PathDataType::CurveTo
  #       data1 = path[i + 1]
  #       data2 = path[i + 2]
  #       data3 = path[i + 3]
  #       printf("CurveTo(%5.2f, %5.2f)\n", data1.point.x, data1.point.y)
  #       printf("       (%5.2f, %5.2f)\n", data2.point.x, data2.point.y)
  #       printf("       (%5.2f, %5.2f)\n", data3.point.x, data3.point.y)
  #   when PathDataType::ClosePath
  #       puts "ClosePath"
  #   end
  #   i += data.header.length
  # end
  # ```
  struct PathData
    def initialize(header : PathDataHeader)
      @data = LibCairo::PathDataT.new
      @data.header = header.to_cairo_path_data_header
    end

    def initialize(point : Point)
      @data = LibCairo::PathDataT.new
      @data.point = point.to_path_data_point
    end

    def initialize(@data : LibCairo::PathDataT)
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
