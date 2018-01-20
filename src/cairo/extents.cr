require "./point"

module Cairo
  struct Extents
    property x1 : Float64 = 0.0
    property y1 : Float64 = 0.0
    property x2 : Float64 = 0.0
    property y2 : Float64 = 0.0

    def initialize
    end

    def initialize(@x1 : Float64, @y1 : Float64, @x2 : Float64, @y2 : Float64)
    end

    def initialize(p1 : Point, p2 : Point)
      @x1 = p1.x
      @y1 = p1.y
      @x2 = p2.x
      @y2 = p2.y
    end

    def p1 : Point
      Point.new(@x1, @y1)
    end

    def p1=(p : Point)
      @x1 = p.x
      @y1 = p.y
    end

    def p2 : Point
      Point.new(@x2, @y2)
    end

    def p2=(p : Point)
      @x2 = p.x
      @y2 = p.y
    end
  end
end
