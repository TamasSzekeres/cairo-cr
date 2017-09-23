require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # Wrapper for LibCairo::MatrixT
  struct Matrix
    def initialize
      @m = LibCairo::MatrixT.new
    end

    def initialize(@m : LibCairo::MatrixT)
    end

    def initialize(xx : Float64, yx : Float64,
                   xy : Float64, yy : Float64,
                   x0 : Float64, y0 : Float64)
      @m = LibCairo::MatrixT.new
      @m.xx = xx
      @m.yx = yx
      @m.xy = xy
      @m.yy = yy
      @m.x0 = x0
      @m.y0 = y0
    end

    def xx : Float64
      @m.xx
    end

    def yx : Float64
      @m.yx
    end

    def xy : Float64
      @m.xy
    end

    def yy : Float64
      @m.yy
    end

    def x0 : Float64
      @m.x0
    end

    def y0 : Float64
      @m.y0
    end

    # Returns the underlieing structure.
    def to_cairo_matrix : LibCairo::MatrixT
      @m
    end

    # Returns the pointer of the underlieing structure.
    def to_unsafe : LibCairo::PMatrixT
      pointerof(@m)
    end
  end
end
