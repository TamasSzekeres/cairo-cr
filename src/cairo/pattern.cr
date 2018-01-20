require "./c/lib_cairo"

module Cairo
  include Cairo::C

  class Pattern
    def initialize(pattern : LibCairo::PPatternT)
      raise ArgumentError.new("'pattern' cannot be null") if pattern.null?
      @pattern = pattern
    end

    def finalize
      LibCairo.pattern_destroy(@pattern)
    end

    # Create Raster Source Pattern
    def self.create_raster_source(user_data : Void*, content : Content, width : Int32, height : Int32) : Pattern
      Pattern.new(LibCairo.pattern_create_raster_source(user_data,
        LibCairo::ContentT.new(content.value), width, height))
    end

    # Create RGB Pattern
    def self.create_rgb(red : Float64, green : Float64, blue : Float64)
      Pattern.new(LibCairo.pattern_create_rgb(red, green, blue))
    end

    # Create RGBA Pattern
    def create_rgba(red : Float64, green : Float64, blue : Float64, alpha : Float64)
      Pattern.new(LibCairo.pattern_create_rgb(red, green, blue, alpha))
    end

    # Create Pattern for Surface
    def self.create_for_surface(surface : Surface)
      Pattern.new(LibCairo.pattern_create_for_surface(surface.to_unsafe))
    end

    # Create Linear Pattern
    def self.create_linear(x0 : Float64, y0 : Float64, x1 : Float64, y1 : Float64)
      Pattern.new(LibCairo.pattern_create_linear(x0, y0, x1, y1))
    end

    # Create Radial Pattern
    def self.create_radial(cx0 : Float64, cy0 : Float64, radius0 : Float64, cx1 : Float64, cy1 : Float64, radius1 : Float64)
      Pattern.new(LibCairo.pattern_create_radial(cx0, cy0, radius0, cx1, cy1, radius1))
    end

    # Create Mesh Pattern
    def self.create_mesh : Pattern
      Pattern.new(LibCairo.pattern_create_mesh)
    end

    def callback_data : Void*
      LibCairo.raster_source_pattern_get_callback_data(@pattern)
    end

    def callback_data=(data : Void*)
      LibCairo.raster_source_pattern_set_callback_data(@pattern, data)
      self
    end

    def acquire : NamedTuple(acquire: LibCairo::RasterSourceAcquireFuncT, release: LibCairo::RasterSourceReleaseFuncT)
      LibCairo.raster_source_pattern_get_acquire(@pattern, out acquire, out release)
      {acquire: acquire, release: release}
    end

    def set_acquire(acquire : LibCairo::RasterSourceAcquireFuncT, release : LibCairo::RasterSourceReleaseFuncT)
      LibCairo.raster_source_pattern_set_acquire(@pattern, acquire, release)
      self
    end

    def snapshot : LibCairo::RasterSourceSnapshotFuncT
      LibCairo.raster_source_pattern_get_snapshot(@pattern)
    end

    def snapshot=(snapshot : LibCairo::RasterSourceSnapshotFuncT)
      LibCairo.raster_source_pattern_set_snapshot(@pattern, snapshot)
      self
    end

    def copy : LibCairo::RasterSourceCopyFuncT
      LibCairo.raster_source_pattern_get_copy(@pattern)
    end

    def copy=(copy : LibCairo::RasterSourceCopyFuncT)
      LibCairo.raster_source_pattern_set_copy(@pattern, copy)
      self
    end

    def finish : LibCairo::RasterSourceFinishFuncT
      LibCairo.raster_source_pattern_get_finish(@pattern)
    end

    def finish=(finish : LibCairo::RasterSourceFinishFuncT)
      LibCairo.raster_source_pattern_set_finish(@pattern, finish)
      self
    end

    def reference : Pattern
      Pattern.new(LibCairo.pattern_reference(@pattern))
    end

    def reference_count : UInt32
      LibCairo.pattern_get_reference_count(@pattern)
    end

    def status : Status
      Status.new(LibCairo.pattern_status(@pattern).value)
    end

    def user_data(key : UserDataKey) : Void*
      LibCairo.pattern_get_user_data(@pattern, key.to_unsafe)
    end

    def set_user_data(key : UserDataKey, user_data : Void*, destroy : LibCairo::DestroyFuncT) : Status
      Status.new(LibCairo.pattern_set_user_data(@pattern, key.to_unsafe, user_data, destroy).value)
    end

    def type : PatternType
      PatternType.new(LibCairo.pattern_get_type(@pattern))
    end

    def add_color_stop(offset : Float64, red : Float64, green : Float64, blue : Float64)
      LibCairo.pattern_add_color_stop_rgb(@pattern, offset, red, green, blue)
      self
    end

    def add_color_stop(offset : Float64, red : Float64, green : Float64, blue : Float64, alpha : Float64)
      LibCairo.pattern_add_color_stop_rgba(@pattern, offset, red, green, blue, alpha)
      self
    end

    def begin_patch
      LibCairo.mesh_pattern_begin_patch(@pattern)
      self
    end

    def end_patch
      LibCairo.mesh_pattern_end_patch(@pattern)
      self
    end

    def curve_to(x1 : Float64, y1 : Float64, x2 : Float64, y2 : Float64, x3 : Float64, y3 : Float64)
      LibCairo.mesh_pattern_curve_to(@pattern, x1, y1, x2, y2, x3, y3)
      self
    end

    def line_to(x : Float64, y : Float64)
      LibCairo.mesh_pattern_line_to(@pattern, x, y)
      self
    end

    def move_to(x : Float64, y : Float64)
      LibCairo.mesh_pattern_move_to(@pattern, x, y)
      self
    end

    def set_control_point(point_num : UInt32, x : Float64, y : Float64)
      LibCairo.mesh_pattern_set_control_point(@pattern, point_num, x, y)
      self
    end

    def set_corner_color(corner_num : UInt32, red : Float64, green : Float64, blue : Float64)
      LibCairo.mesh_pattern_set_corner_color_rgb(@pattern, corner_num, red, green, blue)
      self
    end

    def set_corner_color_rgba(corner_num : UInt32, red : Float64, green : Float64, blue : Float64, alpha : Float64)
      LibCairo.mesh_pattern_set_corner_color_rgba(@pattern, corner_num, red, green, blue, alpha)
      self
    end

    def matrix : Matrix
      matrix = Matrix.new
      LibCairo.pattern_get_matrix(@pattern, matrix.to_unsafe)
      matrix
    end

    def matrix=(matrix : Matrix)
      LibCairo.pattern_set_matrix(@pattern, matrix.to_unsafe)
      self
    end

    def extend : Extend
      Extend.new(LibCairo.pattern_get_extend(@pattern).value)
    end

    def extend=(ex : Extend)
      LibCairo.pattern_set_extend(@pattern, LibCairo::ExtendT.new(ex.value))
      self
    end

    def filter : Filter
      Filter.new(LibCairo.pattern_get_filter(@pattern).value)
    end

    def filter=(filter : Filter)
      LibCairo.pattern_set_filter(@pattern, LibCairo::FilterT.new(filter.value))
      self
    end

    def rgba : RGBA
      status = Status.new(LibCairo.pattern_get_rgba(@pattern, out red, out green, out blue, out alpha).value)
      raise StatusException.new(status) unless status.success?
      RGBA.new(red, green, blue, alpha)
    end

    def surface : Surface
      status = Status.new(LibCairo.pattern_get_surface(@pattern, out surface).value)
      raise StatusException.new(status) unless status.success?
      Surface.new(surface)
    end

    def color_stop(index : Int32) : ColorStop
      status = Status.new(LibCairo.pattern_get_color_stop_rgba(@pattern,
        index, out offset, out red, out green, out blue, out alpha).value)
      raise StatusException.new(status) unless status.success?
      ColorStop.new(offset, red, green, blue, alpha)
    end

    def color_stop_count : Int32
      status = Status.new(pattern_get_color_stop_count(@pattern, out count).value)
      raise StatusException.new(status) unless status.success?
      count
    end

    def linear_points : NamedTuple(x0: Float64, y0: Float64, x1: Float64, y1: Float64)
      status = Status.new(LibCairo.pattern_get_linear_points(@pattern,
        out x0, out y0, out x1, out y1).value)
      raise StatusException.new(status) unless status.success?
      {x0: x0, y0: y0, x1: x1, y1: y1}
    end

    def radial_circles : NamedTuple(x0: Float64, y0: Float64, r0: Float64, x1: Float64, y1: Float64, r1: Float64)
      status = Status.new(LibCairo.pattern_get_radial_circles(@pattern,
        out x0, out y0, out r0, out x1, out y1, out r1).value)
      raise StatusException.new(status) unless status.success?
      {x0: x0, y0: y0, r0: r0, x1: x1, y1: y1, r1: r1}
    end

    def patch_count : UInt32
      status = Status.new(LibCairo.mesh_pattern_get_patch_count(@pattern, out count).value)
      raise StatusException.new(status) unless status.success?
      count
    end

    def path(patch_num : UInt32) : Path
      Path.new(LibCairo.mesh_pattern_get_path(@pattern, patch_num))
    end

    def corner_color(patch_num : UInt32, corner_num : UInt32) : RGBA
      status = Status.new(LibCairo.mesh_pattern_get_corner_color_rgba(@pattern,
        patch_num, corner_num, out red, out green, out blue, out alpha).value)
      raise StatusException.new(status) unless status.success?
      RGBA.new(red, green, blue, alpha)
    end

    def control_point(
      pattern : PPatternT,
      patch_num : UInt32,
      point_num : UInt32,
      x : Float64*,
      y : Float64*) : StatusT
      status = Status.new(LibCairo.mesh_pattern_get_control_point(@pattern,
        patch_num, point_num, out x, out y).value)
      raise StatusException.new(status) unless status.success?
      Point.new(x, y)
    end

    def to_unsafe : LibCairo::PPatternT
      @pattern
    end
  end
end
