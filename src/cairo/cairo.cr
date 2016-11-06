require "./version"

module CairoCr
  def self.version_encode(major, minor, micro)
    (major * 10000) +
    (minor *   100) +
    (micro *     1)
  end

  def self.version
    version_encode(
      CAIRO_VERSION_MAJOR,
      CAIRO_VERSION_MINOR,
      CAIRO_VERSION_MICRO)
  end

  def self.version_stringize(major, minor, micro)
    "#{major}.#{minor}.#{micro}"
  end

  def self.version_string
    version_stringize(
      CAIRO_VERSION_MAJOR,
      CAIRO_VERSION_MINOR,
      CAIRO_VERSION_MICRO)
  end

  @[Link("cairo")]
  lib Cairo
    fun version = cairo_version() : Int32

    fun version_string = cairo_version_string() : UInt8*

    alias BoolT = Int32

    alias PCairoT = Void*

    alias PSurfaceT = Void*

    alias PDeviceT = Void*

    alias PMatrixT = MatrixT*
    struct MatrixT
      xx, yx : Float64
      xy, yy : Float64
      x0, y0 : Float64
    end

  end # lib Cairo
end # module CairoCr
