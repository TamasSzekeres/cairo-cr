require "./c/lib_cairo"
require "./c/xlib"

module Cairo
  include Cairo::C

  # Wrapper for LibCairo::PSurfaceT
  class Surface
    def initialize(surface : LibCairo::PSurfaceT)
      raise ArgumentError.new("'surface' cannot be null.") if surface.null?
      @surface = surface
    end

    # Create Image Surface
    def initialize(format : Format, width : Int32, height : Int32)
      @surface = LibCairo.image_surface_create(LibCairo::FormatT.new(format.value), width, height)
    end

    # Create Image Surface for Data
    def initialize(data : Bytes, format : Format, width : Int32, height : Int32, stride : Int32)
      @surface = LibCairo.image_surface_create_for_data(data.to_unsafe,
        LibCairo::FormatT.new(format.value), width, height, stride)
    end

    {% if Cairo::C::HAS_PNG_FUNCTIONS %}

    # Create Image Surface form PNG
    def initialize(filename : String)
      @surface = LibCairo.image_surface_create_from_png(filename.to_unsafe)
    end

    # Create Image Surface form PNG Stream
    def initialize(read_func : LibCairo::ReadFuncT, closure : Void*)
      @surface = LibCairo.image_surface_create_from_png_stream(read_func, closure)
    end

    {% end %}

    # Create Recording Surface
    def initialize(content : Content, extents : Rectangle?)
      if extents.is_a?(Rectangle)
        @surface = LibCairo.recording_surface_create(
          LibCairo::ContentT.new(content.value),
          extents.as(Rectangle).to_unsafe)
      else
        @surface = LibCairo.recording_surface_create(
          LibCairo::ContentT.new(content.value), nil)
      end
    end

    def finalize
      LibCairo.surface_destroy(@surface)
    end

    def create_similar(content : Content, width : Int32, height : Int32) : Surface
      Surface.new(LibCairo.surface_create_similar(@surface, LibCairo::ContentT.new(content.value), width, height))
    end

    def create_similar_image(format : Format, width : Int32, height : Int32) : Surface
      Surface.new(LibCairo.surface_create_similar_image(@surface, LibCairo::FormatT.new(format.value), width, height))
    end

    def map_to_image(extents : RectangleInt?) : Surface
      if extents.is_a(RectangleInt)
        Surface.new(LibCairo.surface_map_to_image(@surface, extents.as(RectangleInt).to_unsafe))
      else
        Surface.new(LibCairo.surface_map_to_image(@surface, nil))
      end
    end

    def unmap_image(image : Surface)
      LibCairo.surface_unmap_image(@surface, image.to_unsafe)
      self
    end

    def create_for_rectangle(x : Float64, y : Float64, width : Float64, height : Float64) : Surface
      Surface.new(LibCairo.surface_create_for_rectangle(@surface, x, y, width, height))
    end

    def create_observer(mode : SurfaceObserverMode) : Surface
      Surface.new(LibCairo.surface_create_observer(@surface, LibCairo::SurfaceObserverModeT.new(mode.value)))
    end

    def observer_add_paint_callback(func : LibCairo::SurfaceObserverCallbackT, data : Void*) : Status
      Status.new(LibCairo.surface_observer_add_paint_callback(@surface, func, data).value)
    end

    def observer_add_mask_callback(func : LibCairo::SurfaceObserverCallbackT, data : Void*) : Status
      Status.new(LibCairo.surface_observer_add_mask_callback(@surface, func, data).value)
    end

    def observer_add_fill_callback(func : LibCairo::SurfaceObserverCallbackT, data : Void*) : Status
      Status.new(LibCairo.surface_observer_add_fill_callback(@surface, func, data).value)
    end

    def observer_add_stroke_callback(func : LibCairo::SurfaceObserverCallbackT, data : Void*) : Status
      Status.new(LibCairo.surface_observer_add_stroke_callback(@surface, func, data).value)
    end

    def observer_add_glyphs_callback(func : LibCairo::SurfaceObserverCallbackT, data : Void*) : Status
      Status.new(LibCairo.surface_observer_add_glyphs_callback(@surface, func, data).value)
    end

    def observer_add_flush_callback(func : LibCairo::SurfaceObserverCallbackT, data : Void*) : Status
      Status.new(LibCairo.surface_observer_add_flush_callback(@surface, func, data).value)
    end

    def observer_add_finish_callback(func : LibCairo::SurfaceObserverCallbackT, data : Void*) : Status
      Status.new(LibCairo.surface_observer_add_finish_callback(@surface, func, data).value)
    end

    def observer_print(write_func : LibCairo::WriteFuncT, closure : Void*) : Status
      Status.new(LibCairo.surface_observer_print(@surface, write_func, closure).value)
    end

    def observer_elapsed : Float64
      LibCairo.surface_observer_elapsed(@surface)
    end

    def reference : Surface
      Surface.new(LibCairo.surface_reference(@surface))
    end

    def finish
      LibCairo.surface_finish(@surface)
      self
    end

    def device : Device
      Device.new(LibCairo.surface_get_device(@surface))
    end

    def reference_count : UInt32
      LibCairo.surface_get_reference_count(@surface)
    end

    def status : Status
      Status.new(LibCairo.surface_status(@surface).value)
    end

    def get_type : SurfaceType
      SurfaceType.new(LibCairo.surface_get_type(@surface).value)
    end

    def content : Content
      Content.new(LibCairo.surface_get_content(@surface).value)
    end

    {% if Cairo::C::HAS_PNG_FUNCTIONS %}

    def write_to_png(filename : String) : Status
      Status.new(LibCairo.surface_write_to_png(@surface, filename.to_unsafe).value)
    end

    def write_to_png_stream(write_func : LibCairo::WriteFuncT, closure : Void*) : Status
      Status.new(LibCairo.surface_write_to_png_stream(@surface, write_func, closure).value)
    end

    {% end %}

    def user_data(key : UserDataKey) : Void*
      LibCairo.surface_get_user_data(@surface, key.to_unsafe)
    end

    def set_user_data(key : UserDataKey, user_data : Void*, destroy : LibCairo::DestroyFuncT) : Status
      Status.new(LibCairo.surface_set_user_data(@surface, key.to_unsafe, user_data, destroy).value)
    end

    def mime_data(mime_type : String) : Bytes
      LibCairo.surface_get_mime_data(@surface, mime_type.to_unsafe, out data, out length)
      Bytes.new(data, length)
    end

    def set_mime_data(mime_type : String, data : Bytes, destroy : LibCairo::DestroyFuncT, closure : Void*) : Status
      Status.new(LibCairo.surface_set_mime_data(@surface, mime_type.to_unsafe,
        data.to_unsafe, data.size, destroy, closure).value)
    end

    def supports_mime_type?(mime_type : String) : Bool
      LibCairo.surface_supports_mime_type(@surface, mime_type.to_unsafe) == 1
    end

    def font_options : FontOptions
      font_options = FontOptions.new
      LibCairo.surface_get_font_options(@surface, font_options.to_unsafe)
      font_options
    end

    def flush
      LibCairo.surface_flush(@surface)
      self
    end

    def mark_dirty
      LibCairo.surface_mark_dirty(@surface)
      self
    end

    def mark_dirty_rectangle(x : Int32, y : Int32, width : Int32, height : Int32)
      LibCairo.surface_mark_dirty_rectangle(@surface, x, y, width, height)
      self
    end

    def set_device_scale(x_scale : Float64, y_scale : Float64)
      LibCairo.surface_set_device_scale(@surface, x_scale, y_scale)
      self
    end

    def device_scale : Point
      LibCairo.surface_get_device_scale(@surface, out x_scale, out y_scale)
      Point.new(x_scale, x_scale)
    end

    def device_scale=(scale : Point)
      LibCairo.surface_set_device_scale(@surface, scale.x, scale.y)
      self
    end

    def set_device_offset(x_offset : Float64, y_offset : Float64)
      LibCairo.surface_set_device_offset(@surface, x_offset, y_offset)
      self
    end

    def device_offset : Point
      LibCairo.surface_get_device_offset(@surface, out x_offset, out y_offset)
      Point.new(x_offset, y_offset)
    end

    def device_offset=(offset : Point)
      LibCairo.surface_set_device_offset(@surface, offset.x, offset.y)
      self
    end

    def set_fallback_resolution(x_pixels_per_inch : Float64, y_pixels_per_inch : Float64)
      LibCairo.surface_set_fallback_resolution(@surface, x_pixels_per_inch, y_pixels_per_inch)
      self
    end

    def fallback_resolution : Point
      LibCairo.surface_get_fallback_resolution(@surface, out x_ppi, out y_ppi)
      Point.new(x_ppi, y_ppi)
    end

    def fallback_resolution=(res : Point)
      LibCairo.surface_set_fallback_resolution(@surface, res.x, res.y)
      self
    end

    def copy_page
      LibCairo.surface_copy_page(@surface)
      self
    end

    def surface_show_page
      LibCairo.surface_show_page(@surface)
      self
    end

    def has_show_text_glyphs? : Bool
      LibCairo.surface_has_show_text_glyphs(@surface) == 2
    end

    def data : String
      String.new(LibCairo.image_surface_get_data(@surface))
    end

    def format : Format
      Format.new(LibCairo.image_surface_get_format(@surface).value)
    end

    def width : Int32
      LibCairo.image_surface_get_width(@surface)
    end

    def height : Int32
      LibCairo.image_surface_get_height(@surface)
    end

    def stride : Int32
      LibCairo.image_surface_get_stride(@surface)
    end

    def ink_extents : Rectangle
      LibCairo.recording_surface_ink_extents(@surface, out x0, out y0, out width, out height)
      Rectangle.new(x1, y1, width, height)
    end

    def extents : NamedTuple(extents: Rectangle, bounded: Bool)
      bounded = LibCairo.recording_surface_get_extents(@surface, out extents) == 1
      {extents: extents, bounded: bounded}
    end

    def to_unsafe : LibCairo::PSurfaceT
      @surface
    end
  end
end
