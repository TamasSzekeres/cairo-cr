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

    def xx=(xx : Float64)
      @m.xx = xx
    end

    def yx : Float64
      @m.yx
    end

    def yx=(yx : Float64)
      @m.yx = yx
    end

    def xy : Float64
      @m.xy
    end

    def xy=(xy : Float64)
      @m.xy = xy
    end

    def yy : Float64
      @m.yy
    end

    def yy=(yy : Float64)
      @m.yy = yy
    end

    def x0 : Float64
      @m.x0
    end

    def x0=(x0 : Float64)
      @m.x0 = x0
    end

    def y0 : Float64
      @m.y0
    end

    def y0=(y0 : Float64)
      @m.y0 = y0
    end

    def init(xx : Float64, yx : Float64, xy : Float64, yy : Float64, x0 : Float64, y0 : Float64)
      LibCairo.matrix_init(to_unsafe, xx, yx, xy, yy, x0, y0)
      self
    end

    def init_identity
      LibCairo.matrix_init_identity(to_unsafe)
      self
    end

    def init_translate(tx : Float64, ty : Float64)
      LibCairo.matrix_init_translate(to_unsafe, tx, ty)
      self
    end

    def init_scale(sx : Float64, sy : Float64)
      LibCairo.matrix_init_scale(to_unsafe, sx, sy)
      self
    end

    def init_rotate(radians : Float64)
      LibCairo.matrix_init_rotate(to_unsafe, radians)
      self
    end

    def translate(tx : Float64, ty : Float64)
      LibCairo.matrix_translate(to_unsafe, tx, ty)
      self
    end

    def scale(sx : Float64, sy : Float64)
      LibCairo.matrix_scale(to_unsafe, sx, sy)
      self
    end

    def rotate(radians : Float64)
      LibCairo.matrix_rotate(to_unsafe, radians)
      self
    end

    def invert : Status
      Status.new(LibCairo.matrix_invert(to_unsafe).value)
    end

    def multiply(a : Matrix, b : Matrix)
      LibCairo.matrix_multiply(to_unsafe, a.to_unsafe, b.to_unsafe)
      self
    end

    def transform_distance(d : Point) : Point
      dx = d.x
      dy = d.y
      LibCairo.matrix_transform_distance(to_unsafe,
        pointerof(dx), pointerof(dy))
      Point.new(dx, dy)
    end

    def transform_point(p : Point) : Point
      x = p.x
      y = p.y
      LibCairo.matrix_transform_point(to_unsafe,
        pointerof(x), pointerof(y))
      Point.new(x, y)
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
