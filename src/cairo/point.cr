require "./c//lib_cairo"

module Cairo
  include Cairo::C

  struct Point
    property x : Float64 = 0.0
    property y : Float64 = 0.0

    def initialize
    end

    def initialize(@x : Float64, @y : Float64)
    end

    def initialize(point : LibCairo::PathDataPointT)
      @x = point.x
      @y = point.y
    end

    def to_path_data_point : LibCairo::PathDataPointT
      point = LibCairo::PathDataPointT.new
      point.x = @x
      point.y = @y
      point
    end
  end
end
