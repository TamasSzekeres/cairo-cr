require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # Wrapper for LibCairo::MatrixT
  #
  # `Matrix` is used throughout cairo to convert between different coordinate spaces.
  # A `Matrix` holds an affine transformation, such as a scale, rotation, shear, or a combination of these.
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

    # Sets matrix to be the affine transformation given by *xx*, *yx*, *xy*, *yy*, *x0*, *y0*. The transformation is given by:
    # ```
    # x_new = xx * x + xy * y + x0
    # y_new = yx * x + yy * y + y0
    # ```
    #
    # ###Parameters
    # - **xx** xx component of the affine transformation
    # - **yx** yx component of the affine transformation
	  # - **xy** xy component of the affine transformation
    # - **yy** yy component of the affine transformation
    # - **x0** X translation component of the affine transformation
    # - **y0** Y translation component of the affine transformation
    def init(xx : Float64, yx : Float64, xy : Float64, yy : Float64, x0 : Float64, y0 : Float64)
      LibCairo.matrix_init(to_unsafe, xx, yx, xy, yy, x0, y0)
      self
    end

    # Modifies matrix to be an identity transformation.
    def init_identity
      LibCairo.matrix_init_identity(to_unsafe)
      self
    end

    # Initializes matrix to a transformation that translates by *tx* and *ty* in the *X* and *Y* dimensions, respectively.
    #
    # ###Parameters
    # - **tx** amount to translate in the X direction
    # - **ty** amount to translate in the Y direction
    def init_translate(tx : Float64, ty : Float64)
      LibCairo.matrix_init_translate(to_unsafe, tx, ty)
      self
    end

    # Initializes matrix to a transformation that scales by *sx* and *sy* in the *X* and *Y* dimensions, respectively.
    #
    # ###Parameters
    # - **sx** scale factor in the X direction
    # - **sy** scale factor in the Y direction
    def init_scale(sx : Float64, sy : Float64)
      LibCairo.matrix_init_scale(to_unsafe, sx, sy)
      self
    end

    # Initialized matrix to a transformation that rotates by radians.
    #
    # ###Parameters
    # - **radians** angle of rotation, in radians.
    # The direction of rotation is defined such that positive angles rotate in the direction
    # from the positive X axis toward the positive Y axis. With the default axis orientation of cairo,
    # positive angles rotate in a clockwise direction.
    def init_rotate(radians : Float64)
      LibCairo.matrix_init_rotate(to_unsafe, radians)
      self
    end

    # Applies a translation by *tx*, *ty* to the transformation in matrix.
    # The effect of the new transformation is to first translate the coordinates by *tx* and *ty*,
    # then apply the original transformation to the coordinates.
    #
    # ###Parameters
    # - **tx** amount to translate in the X direction
    # - **ty** amount to translate in the Y direction
    def translate(tx : Float64, ty : Float64)
      LibCairo.matrix_translate(to_unsafe, tx, ty)
      self
    end

    # Applies scaling by *sx*, *sy* to the transformation in matrix.
    # The effect of the new transformation is to first scale the coordinates by *sx* and *sy*,
    # then apply the original transformation to the coordinates.
    #
    # ###Parameters
    # - **sx** scale factor in the X direction
    # - **sy** scale factor in the Y direction
    def scale(sx : Float64, sy : Float64)
      LibCairo.matrix_scale(to_unsafe, sx, sy)
      self
    end

    # Applies rotation by radians to the transformation in matrix.
    # The effect of the new transformation is to first rotate the coordinates by radians,
    # then apply the original transformation to the coordinates.
    #
    # ###Parameters
    # - **radians** angle of rotation, in radians.
    # The direction of rotation is defined such that positive angles rotate in the direction
    # from the positive X axis toward the positive Y axis. With the default axis orientation of cairo,
    # positive angles rotate in a clockwise direction.
    def rotate(radians : Float64)
      LibCairo.matrix_rotate(to_unsafe, radians)
      self
    end

    # Changes matrix to be the inverse of its original value. Not all transformation matrices have inverses;
    # if the matrix collapses points together (it is degenerate), then it has no inverse and this function will fail.
    #
    ###Returns
    # If matrix has an inverse, modifies matrix to be the inverse matrix and returns
    # `Status::Success`. Otherwise, returns `Status::InvalidMatrix`.
    def invert : Status
      Status.new(LibCairo.matrix_invert(to_unsafe).value)
    end

    # Multiplies the affine transformations in *a* and *b* together and returns the result.
    # The effect of the resulting transformation is to first apply the transformation in *a* to the coordinates
    # and then apply the transformation in *b* to the coordinates.
    #
    # It is allowable for result to be identical to either *a* or *b*.
    #
    # ###Parameters
    # - **a** a `Matrix`
    # - **b** a `Matrix`
    def multiply(a : Matrix, b : Matrix)
      LibCairo.matrix_multiply(to_unsafe, a.to_unsafe, b.to_unsafe)
      self
    end

    # Transforms the distance vector *(dx, dy)* by matrix.
    # This is similar to `Matrix#transform_point` except that the translation components
    # of the transformation are ignored. The calculation of the returned vector is as follows:
    # ```
    # dx2 = dx1 * a + dy1 * c
    # dy2 = dx1 * b + dy1 * d
    # ```
    #
    # Affine transformations are position invariant, so the same vector always transforms to the same vector.
    # If *(x1, y1)* transforms to *(x2, y2)* then *(x1 + dx1, y1 + dy1)* will transform
    # to *(x1 + dx2, y1 + dy2)* for all values of *x1* and *x2*.
    #
    # ###Parameters
    # - **dx** X component of a distance vector.
    # - **dy** Y component of a distance vector.
    #
    # ###Returns
    # Transformed vector.
    def transform_distance(d : Point) : Point
      dx = d.x
      dy = d.y
      LibCairo.matrix_transform_distance(to_unsafe,
        pointerof(dx), pointerof(dy))
      Point.new(dx, dy)
    end

    # Transforms the point *(x, y)* by matrix.
    #
    # ###Parameters
    # - **x** X position.
    # - **y** Y position.
    #
    # ###Returns
    # Transformed vector.
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
