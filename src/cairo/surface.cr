require "./c/lib_cairo"
require "./c/xlib"

module Cairo
  include Cairo::C

  # `Surface` is the abstract type representing all different drawing targets that cairo can render to.
  # The actual drawings are performed using a cairo context.
  #
  # A cairo surface is created by using backend-specific constructors, typically of the form `Surface#initialize`.
  #
  # Most surface types allow accessing the surface without using Cairo functions.
  # If you do this, keep in mind that it is mandatory that you call `Surface#flush` before
  # reading from or writing to the surface and that you must use `Surface#mark_dirty` after modifying it.
  #
  # NOTE that for other surface types it might be necessary to acquire the surface's device first.
  # See `Device#acquire` for a discussion of devices.
  #
  #
  # A `Surface` represents an image, either as the destination of a drawing operation or as source when drawing onto another surface.
  # To draw to a `Surface`, create a cairo context with the surface as the target, using `Context#create(Surface)`.
  #
  # There are different subtypes of `Surface` for different drawing backends; for example,
  # `Surface#initialize(Format, Int32, Int32)` creates a bitmap image in memory.
  # The type of a surface can be queried with `Surface#type`.
  #
  # The initial contents of a surface after creation depend upon the manner of its creation.
  # If cairo creates the surface and backing storage for the user, it will be initially cleared;
  # for example, `Surface#initialize(Format, Int32, Int32)` and `Surface#create_similar`.
  # Alternatively, if the user passes in a reference to some backing storage and asks cairo to wrap
  # that in a `Surface`, then the contents are not modified; for example,
  # `Surface#initialize(Bytes, Format, Int32, Int32, Int32)` and `XlibSurface#initialize`.
  #
  # Memory management of `Surface` is done with `Surface#reference` and `Surface#finalize`.
  class Surface
    def initialize(surface : LibCairo::PSurfaceT)
      raise ArgumentError.new("'surface' cannot be null.") if surface.null?
      @surface = surface
    end

    # Creates an image surface of the specified format and dimensions.
    # Initially the surface contents are set to 0. (Specifically, within each pixel,
    # each color or alpha channel belonging to format will be 0. The contents of
    # bits within a pixel, but not belonging to the given format are undefined).
    #
    # ###Parameters
    # - **format** format of pixels in the surface to create
    # - **width** width of the surface, in pixels
    # - **height** height of the surface, in pixels
    #
    # ###Returns
    # A pointer to the newly created surface. The caller owns the surface and
    # should call `Surface#finalize when done with it.
    #
    # This function always returns a valid pointer, but it will return a pointer
    # to a "nil" surface if an error such as out of memory occurs.
    # You can use `Surface#status` to check for this.
    def initialize(format : Format, width : Int32, height : Int32)
      @surface = LibCairo.image_surface_create(LibCairo::FormatT.new(format.value), width, height)
    end

    # Creates an image surface for the provided pixel data. The output buffer
    # must be kept around until the `Surface` is destroyed or `Surface#finish`
    # is called on the surface. The initial contents of data will be used as
    # the initial image contents; you must explicitly clear the buffer, using,
    # for example, `Context#rectangle` and `Context#fill` if you want it cleared.
    #
    # NOTE: that the stride may be larger than `width * bytes_per_pixel` to
    # provide proper alignment for each pixel and row. This alignment is
    # required to allow high-performance rendering within cairo. The correct
    # way to obtain a legal stride value is to call `Format#stride_for_width`
    # with the desired format and maximum image width value, and then use the
    # resulting stride value to allocate the data and to create the image surface.
    # See `Format#stride_for_width` for example code.
    #
    # ###Parameters
    # - **data** a pointer to a buffer supplied by the application in which to
    # write contents. This pointer must be suitably aligned for any kind of variable.
    # - **format** the format of pixels in the buffer
    # - **width** the width of the image to be stored in the buffer
    # - **height** the height of the image to be stored in the buffer
    # - **stride** the number of bytes between the start of rows in the
    # buffer as allocated. This value should always be computed by `Format#stride_for_width`
    # before allocating the data buffer.
    #
    # ###Returns
    # A pointer to the newly created surface. The caller owns the surface and
    # should call `Surface#finalize` when done with it.
    #
    # This function always returns a valid pointer, but it will return a
    # pointer to a "nil" surface in the case of an error such as out of memory
    # or an invalid stride value. In case of invalid stride value the error
    # status of the returned surface will be `Status::InvalidStride`.
    # You can use `Surface#status` to check for this.
    #
    # See `Surface#set_user_data` for a means of attaching a
    # destroy-notification fallback to the surface if necessary.
    def initialize(data : Bytes, format : Format, width : Int32, height : Int32, stride : Int32)
      @surface = LibCairo.image_surface_create_for_data(data.to_unsafe,
        LibCairo::FormatT.new(format.value), width, height, stride)
    end

    {% if Cairo::C::HAS_PNG_FUNCTIONS %}

    # Creates a new image surface and initializes the contents to the given PNG file.
    #
    # ###Parameters
    # - **filename** name of PNG file to load. On Windows this filename is encoded in UTF-8.
    #
    # ###Returns
    # A new `Surface` initialized with the contents of the PNG file,
    # or a "nil" surface if any error occurred. A nil surface can be checked
    # for with `Surface#status` which may return one of the following values:
    #
    # `Status#NoMemory` `Status#FileNotFound` `Status#ReadError` `Status#PngError`
    #
    # Alternatively, you can allow errors to propagate through the drawing
    # operations and check the status on the context upon completion using
    # `Context#status`.
    def initialize(filename : String)
      @surface = LibCairo.image_surface_create_from_png(filename.to_unsafe)
    end

    # Creates a new image surface from PNG data read incrementally via the
    # *read_func* function.
    #
    # ###Parameters
    # - **read_func** function called to read the data of the file
    # - **closure** data to pass to *read_func*.
    #
    # ###Returns
    # A new `Surface` initialized with the contents of the PNG file or a "nil"
    # surface if the data read is not a valid PNG image or memory could not be
    # allocated for the operation. A nil surface can be checked for with
    # `Surface#status` which may return one of the following values:
    #
    # `Status#NoMemory` `Status#ReadError` `Status#PngError`
    #
    # Alternatively, you can allow errors to propagate through the drawing
    # operations and check the status on the context upon completion
    # using `Context#status`.
    def initialize(read_func : LibCairo::ReadFuncT, closure : Void*)
      @surface = LibCairo.image_surface_create_from_png_stream(read_func, closure)
    end

    {% end %}

    {% if Cairo::C::HAS_RECORDING_SURFACE %}

    # Creates a recording-surface which can be used to record all drawing
    # operations at the highest level (that is, the level of paint, mask,
    # stroke, fill and show_text_glyphs). The recording surface can then be
    # "replayed" against any target surface by using it as a source
    # to drawing operations.
    #
    # The recording phase of the recording surface is careful to snapshot all
    # necessary objects (paths, patterns, etc.), in order to achieve accurate replay.
    #
    # ###Parameters
    # - **content** the content of the recording surface
    # - **extents** the extents to record in pixels, can be `nil` to record unbounded operations.
    #
    # ###Returns
    # A pointer to the newly created surface. The caller owns the surface and should
    # call `Surface#finalize` when done with it.
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

    {% end %}

    # Decreases the reference count on surface by one. If the result is zero,
    # then surface and all associated resources are freed. See `Surface#reference`.
    def finalize
      LibCairo.surface_destroy(@surface)
    end

    # Create a new surface that is as compatible as possible with an existing surface.
    # For example the new surface will have the same device scale, fallback resolution
    # and font options as `self`. Generally, the new surface will also use the same backend as `self`,
    # unless that is not possible for some reason.
    # The type of the returned surface may be examined with `Surface#type`.
    #
    # Initially the surface contents are all 0 (transparent if contents have transparency, black otherwise.)
    #
    # Use `Surface#create_similar_image` if you need an image surface which can be painted quickly to the target surface.
    #
    # ###Parameters
    # - **content** the content for the new surface
    # - **width** width of the new surface, (in device-space units)
    # - **height** height of the new surface (in device-space units)
    #
    # ###Returns
    # A pointer to the newly allocated surface. The caller owns the surface and should
    # call `Surface#finalize` when done with it.
    #
    # This function always returns a valid pointer, but it will return a pointer to a "nil" surface
    # if other is already in an error state or any other error occurs.
    def create_similar(content : Content, width : Int32, height : Int32) : Surface
      Surface.new(LibCairo.surface_create_similar(@surface, LibCairo::ContentT.new(content.value), width, height))
    end

    # Create a new image surface that is as compatible as possible for uploading to and the use
    # in conjunction with an existing surface. However, this surface can still be used like any
    # normal image surface. Unlike `Surface#create_similar` the new image surface won't inherit the device scale from `self`.
    #
    # Initially the surface contents are all 0 (transparent if contents have transparency, black otherwise.)
    #
    # Use `Surface#create_similar` if you don't need an image surface.
    #
    # ###Parameters
    # - **format** the format for the new surface
    # - **width** width of the new surface, (in pixels)
    # - **height** height of the new surface (in pixels)
    #
    # ###Returns
    # A pointer to the newly allocated image surface.
    # The caller owns the surface and should call `Surface#finalizte` when done with it.
    #
    # This function always returns a valid pointer, but it will return a pointer to a "nil" surface
    # if other is already in an error state or any other error occurs.
    def create_similar_image(format : Format, width : Int32, height : Int32) : Surface
      Surface.new(LibCairo.surface_create_similar_image(@surface, LibCairo::FormatT.new(format.value), width, height))
    end

    # Returns an image surface that is the most efficient mechanism for modifying the backing store of the target surface.
    # The region retrieved may be limited to the extents or `nil` for the whole surface
    #
    # NOTE, the use of the original surface as a target or source whilst it is mapped is undefined.
    # The result of mapping the surface multiple times is undefined. Calling `Surface#finalize` or
    # `Surface#finish` on the resulting image surface results in undefined behavior.
    # Changing the device transform of the image surface or of surface before the image surface is unmapped results in undefined behavior.
    #
    # ###Parameters
    # - **extents** limit the extraction to an rectangular region
    #
    # ###Returns
    # A pointer to the newly allocated image surface. The caller must use `Surface#unmap_image` to destroy this image surface.
    #
    # This function always returns a valid pointer, but it will return a pointer to a "nil" surface if other is already in
    # an error state or any other error occurs. If the returned pointer does not have an error status,
    # it is guaranteed to be an image surface whose format is not `Format::Invalid`.
    def map_to_image(extents : RectangleInt?) : Surface
      if extents.is_a(RectangleInt)
        Surface.new(LibCairo.surface_map_to_image(@surface, extents.as(RectangleInt).to_unsafe))
      else
        Surface.new(LibCairo.surface_map_to_image(@surface, nil))
      end
    end

    # Unmaps the image surface as returned from `Surface#map_to_image`.
    #
    # The content of the image will be uploaded to the target surface. Afterwards, the image is destroyed.
    #
    # Using an image surface which wasn't returned by `Surface#map_to_image` results in undefined behavior.
    #
    # ###Parameters
    # - **image** the currently mapped image
    def unmap_image(image : Surface)
      LibCairo.surface_unmap_image(@surface, image.to_unsafe)
      self
    end

    # Create a new surface that is a rectangle within the target surface.
    #
    # All operations drawn to this surface are then clipped and translated onto the target surface.
    # Nothing drawn via this sub-surface outside of its bounds is drawn onto the target surface,
    # making this a useful method for passing constrained child surfaces to library routines that draw
    # directly onto the parent surface, i.e. with no further backend allocations, double buffering or copies.
    #
    # The semantics of subsurfaces have not been finalized yet unless the rectangle is in full device units,
    # is contained within the extents of the target surface, and the target or subsurface's device transforms are not changed.
    #
    # ###Parameters
    # - **x** the x-origin of the sub-surface from the top-left of the target surface (in device-space units)
    # - **y** the y-origin of the sub-surface from the top-left of the target surface (in device-space units)
    # - **width** width of the sub-surface (in device-space units)
    # - **height** height of the sub-surface (in device-space units)
    #
    # ###Returns
    # A pointer to the newly allocated surface. The caller owns the surface and should call `Surface#finalize` when done with it.
    #
    # This function always returns a valid pointer, but it will return a pointer to a "nil" surface
    # if other is already in an error state or any other error occurs.
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

    # Increases the reference count on surface by one.
    # This prevents surface from being destroyed until a matching call to `Surface#finalize` is made.
    #
    # Use `Surface#reference_count` to get the number of references to a `Surface`.
    #
    # ###Returns
    # The referenced `Surface`.
    def reference : Surface
      Surface.new(LibCairo.surface_reference(@surface))
    end

    # This function finishes the surface and drops all references to external resources.
    # For example, for the Xlib backend it means that cairo will no longer access the drawable,
    # which can be freed. After calling `Surface#finish` the only valid operations on a surface
    # are getting and setting user, referencing and destroying, and flushing and finishing it.
    # Further drawing to the surface will not affect the surface but will instead trigger a `Status::SurfaceFinished` error.
    #
    # When the last call to `Surface#finalize` decreases the reference count to zero, cairo will call
    # `Surface#finish` if it hasn't been called already, before freeing the resources associated with the surface.
    def finish
      LibCairo.surface_finish(@surface)
      self
    end

    # This function returns the device for a surface. See `Device`.
    #
    # ###Returns
    # The device for surface or `Nil` if the surface does not have an associated device.
    def device : Device
      Device.new(LibCairo.surface_get_device(@surface))
    end

    # Returns the current reference count of surface.
    #
    # ###Returns
    # The current reference count of surface. If the object is a `nil` object, 0 will be returned.
    def reference_count : UInt32
      LibCairo.surface_get_reference_count(@surface)
    end

    # Checks whether an error has previously occurred for this surface.
    #
    # ###Returns
    # `Status::Success`, `Status::NullPointer`, `Status::NoMemory`, `Status::ReadError`,
    # `Status::InvalidContent`, `Status::InvalidFormat`, or `Status::InvalidVisual`.
    def status : Status
      Status.new(LibCairo.surface_status(@surface).value)
    end

    # This function returns the type of the backend used to create a surface. See `SurfaceType` for available types.
    #
    # ###Returns
    # The type of surface.
    def type : SurfaceType
      SurfaceType.new(LibCairo.surface_get_type(@surface).value)
    end

    # This function returns the content type of surface which indicates whether the
    # surface contains color and/or alpha information. See `Content`.
    #
    # ###Returns
    # The content type of surface.
    def content : Content
      Content.new(LibCairo.surface_get_content(@surface).value)
    end

    {% if Cairo::C::HAS_PNG_FUNCTIONS %}

    # Writes the contents of surface to a new file filename as a PNG image.
    #
    # ###Parameters
    # - **surface** a `Surface` with pixel contents
    # - **filename** the name of a file to write to;
    # on Windows this filename is encoded in UTF-8.
    #
    # ###Returns
    # `Status#success` if the PNG file was written successfully.
    # Otherwise, `Status#NoMemory` if memory could not be allocated for the
    # operation or `Status#SurfaceTypeMismatch` if the surface does not have
    # pixel contents, or `Status#WriteError` if an I/O error occurs while
    # attempting to write the file, or `Status#PngError` if libpng returned an error.
    def write_to_png(filename : String) : Status
      Status.new(LibCairo.surface_write_to_png(@surface, filename.to_unsafe).value)
    end

    # Writes the image surface to the write function.
    #
    # ###Parameters
    # - **surface** a `Surface` with pixel contents
    # - **write_func** a `Cairo::C::LibCairo::WriteFuncT`
    # - **closure** closure data for the write function
    #
    # ###Returns
    # `Status#Success` if the PNG file was written successfully.
    # Otherwise, `Status#NoMemory` is returned if memory could not be allocated
    # for the operation, `Status#SurfaceTypeMismatch` if the surface does not
    # have pixel contents, or `Status#PngError` if libpng returned an error.
    def write_to_png_stream(write_func : LibCairo::WriteFuncT, closure : Void*) : Status
      Status.new(LibCairo.surface_write_to_png_stream(@surface, write_func, closure).value)
    end

    {% end %}

    # Return user data previously attached to surface using the specified key.
    # If no user data has been attached with the given key this function returns `Nil`.
    #
    # ###Parameters
    # - **key** the address of the `UserDataKey` the user data was attached to
    #
    # ###Returns
    # The user data previously attached or `Nil`.
    def user_data(key : UserDataKey) : Void*
      LibCairo.surface_get_user_data(@surface, key.to_unsafe)
    end

    # Attach user data to surface. To remove user data from a surface,
    # call this function with the key that was used to set it and `Nil` for data .
    #
    # ###Parameters
    # - **key** the address of a `UserDataKey` to attach the user data to
    # - **user_data** the user data to attach to the surface
    # - **destroy** a `LibCairo::DestroyFuncT` which will be called when the surface is
    # destroyed or when new user data is attached using the same key.
    #
    # ###Returns
    # `Status#Success` or `Status::NoMemory` if a slot could not be allocated for the user data.
    def set_user_data(key : UserDataKey, user_data : Void*, destroy : LibCairo::DestroyFuncT) : Status
      Status.new(LibCairo.surface_set_user_data(@surface, key.to_unsafe, user_data, destroy).value)
    end

    # Return mime data previously attached to surface using the specified mime type.
    # If no data has been attached with the given mime type, data is set empty.
    #
    # ###Parameters
    # - **mime_type** the mime type of the image data
    #
    # ###Returns
    # The image data to attached to the surface.
    def mime_data(mime_type : String) : Bytes
      LibCairo.surface_get_mime_data(@surface, mime_type.to_unsafe, out data, out length)
      Bytes.new(data, length)
    end

    # Attach an image in the format *mime_type* to surface.
    # To remove the data from a surface, call this function with same mime type and empty *data*.
    #
    # The attached image (or filename) data can later be used by backends which support it
    # (currently: PDF, PS, SVG and Win32 Printing surfaces) to emit this data instead of making a snapshot of the surface.
    # This approach tends to be faster and requires less memory and disk space.
    #
    # The recognized MIME types are the following: `LibCairo::MIME_TYPE_JPEG`, `LibCaito::MIME_TYPE_PNG`,
    # `LibCairo::MIME_TYPE_JP2`, `LibCairo::MIME_TYPE_URI`, `LibCairo::MIME_TYPE_UNIQUE_ID`,
    # `LibCairo::MIME_TYPE_JBIG2`, `LibCairo::MIME_TYPE_JBIG2_GLOBAL`, `LibCairo::MIME_TYPE_JBIG2_GLOBAL_ID`,
    # `LibCairo::MIME_TYPE_CCITT_FAX`, `LibCairo::MIME_TYPE_CCITT_FAX_PARAMS`.
    #
    # See corresponding backend surface docs for details about which MIME types it can handle.
    # Caution: the associated MIME data will be discarded if you draw on the surface afterwards. Use this function with care.
    #
    # Even if a backend supports a MIME type, that does not mean cairo will always be able to use the attached MIME data.
    # For example, if the backend does not natively support the compositing operation used to apply the MIME data to the backend.
    # In that case, the MIME data will be ignored. Therefore, to apply an image in all cases, it is best to create an image surface
    # which contains the decoded image data and then attach the MIME data to that.
    # This ensures the image will always be used while still allowing the MIME data to be used whenever possible.
    #
    # ###Parameters
    # - **mime_type** the MIME type of the image data
    # - **data** the image data to attach to the surface
    # - **destroy** a `LibCairo::DestroyFuncT` which will be called when the surface is
    # destroyed or when new image data is attached using the same mime type.
    # - **closure** the data to be passed to the destroy notifier
    #
    # ###Returns
    # `Status::Success` or `Status::NoMemory` if a slot could not be allocated for the user data.
    def set_mime_data(mime_type : String, data : Bytes, destroy : LibCairo::DestroyFuncT, closure : Void*) : Status
      Status.new(LibCairo.surface_set_mime_data(@surface, mime_type.to_unsafe,
        data.to_unsafe, data.size, destroy, closure).value)
    end

    # Return whether surface supports *mime_type*.
    #
    # ###Parameters
    # - **mime_type** the mime type
    #
    # ###Returns
    # `true` if surface supports *mime_type*, `false` otherwise.
    def supports_mime_type?(mime_type : String) : Bool
      LibCairo.surface_supports_mime_type(@surface, mime_type.to_unsafe) == 1
    end

    # Retrieves the default font rendering options for the surface.
    # This allows display surfaces to report the correct subpixel order for rendering on them,
    # print surfaces to disable hinting of metrics and so forth.
    # The result can then be used with `ScaledFont#initialize`.
    #
    # ###Returns
    # A `FontOptions` object into which to store the retrieved options. All existing values are overwritten.
    def font_options : FontOptions
      font_options = FontOptions.new
      LibCairo.surface_get_font_options(@surface, font_options.to_unsafe)
      font_options
    end

    # Do any pending drawing for the surface and also restore any temporary modifications cairo has made to the surface's state.
    # This function must be called before switching from drawing on the surface with cairo to drawing on it directly with native APIs,
    # or accessing its memory outside of Cairo. If the surface doesn't support direct access, then this function does nothing.
    def flush
      LibCairo.surface_flush(@surface)
      self
    end

    # Tells cairo that drawing has been done to surface using means other than cairo,
    # and that cairo should reread any cached areas.
    # NOTE that you must call `Surface#flush` before doing such drawing.
    def mark_dirty
      LibCairo.surface_mark_dirty(@surface)
      self
    end

    # Like `Surface#mark_dirty`, but drawing has been done only to the specified rectangle,
    # so that cairo can retain cached contents for other parts of the surface.
    #
    # Any cached clip set on the surface will be reset by this function,
    # to make sure that future cairo calls have the clip set that they expect.
    #
    # ###Parameters
    # - **x** X coordinate of dirty rectangle
    # - **y** Y coordinate of dirty rectangle
    # - **width** width of dirty rectangle
    # - **height** height of dirty rectangle
    def mark_dirty_rectangle(x : Int32, y : Int32, width : Int32, height : Int32)
      LibCairo.surface_mark_dirty_rectangle(@surface, x, y, width, height)
      self
    end

    def set_device_scale(x_scale : Float64, y_scale : Float64)
      LibCairo.surface_set_device_scale(@surface, x_scale, y_scale)
      self
    end

    # This function returns the previous device offset set by `Surface#device_scale=`.
    #
    # ###Returns
    # A `Point` contains **x** and **y** scale in device units
    def device_scale : Point
      LibCairo.surface_get_device_scale(@surface, out x_scale, out y_scale)
      Point.new(x_scale, x_scale)
    end

    # Sets a scale that is multiplied to the device coordinates determined by the CTM when drawing to surface.
    # One common use for this is to render to very high resolution display devices at a scale factor,
    # so that code that assumes 1 pixel will be a certain size will still work.
    # Setting a transformation via Context#translate` isn't sufficient to do this,
    # since functions like `Context#device_to_user` will expose the hidden scale.
    #
    # NOTE that the scale affects drawing to the surface as well as using the surface in a source pattern.
    #
    # ###Parameters
    # - **scale.x** a scale factor in the X direction
    # - **scale.y** a scale factor in the Y direction
    def device_scale=(scale : Point)
      LibCairo.surface_set_device_scale(@surface, scale.x, scale.y)
      self
    end

    def set_device_offset(x_offset : Float64, y_offset : Float64)
      LibCairo.surface_set_device_offset(@surface, x_offset, y_offset)
      self
    end

    # This function returns the previous device offset set by `Surface#device_offset=`.
    #
    # ###Returns
    # A `Point` contains **x** and **y** offset in device units
    def device_offset : Point
      LibCairo.surface_get_device_offset(@surface, out x_offset, out y_offset)
      Point.new(x_offset, y_offset)
    end

    # Sets an offset that is added to the device coordinates determined by the CTM when drawing to surface.
    # One use case for this function is when we want to create a `Surface` that redirects drawing for
    # a portion of an onscreen surface to an offscreen surface in a way that is completely invisible
    # to the user of the cairo API. Setting a transformation via `Context#translate` isn't sufficient to do this,
    # since functions like `Context#device_to_user` will expose the hidden offset.
    #
    # NOTE that the offset affects drawing to the surface as well as using the surface in a source pattern.
    #
    # ###Parameters
    # - **offset.x** the offset in the X direction, in device units
    # - **offset.y** the offset in the Y direction, in device units
    def device_offset=(offset : Point)
      LibCairo.surface_set_device_offset(@surface, offset.x, offset.y)
      self
    end

    def set_fallback_resolution(x_pixels_per_inch : Float64, y_pixels_per_inch : Float64)
      LibCairo.surface_set_fallback_resolution(@surface, x_pixels_per_inch, y_pixels_per_inch)
      self
    end

    # This function returns the previous fallback resolution set by
    # `Surface#fallback_resolution=`, or default fallback resolution if never set.
    #
    # ###Returns
    # A `Point` contains **x** for horizontal and **y** for vertical pixels per inch.
    def fallback_resolution : Point
      LibCairo.surface_get_fallback_resolution(@surface, out x_ppi, out y_ppi)
      Point.new(x_ppi, y_ppi)
    end

    # Set the horizontal and vertical resolution for image fallbacks.
    #
    # When certain operations aren't supported natively by a backend,
    # cairo will fallback by rendering operations to an image and then overlaying that image onto the output.
    # For backends that are natively vector-oriented, this function can be used to set the resolution used
    # for these image fallbacks, (larger values will result in more detailed images, but also larger file sizes).
    #
    # Some examples of natively vector-oriented backends are the ps, pdf, and svg backends.
    #
    # For backends that are natively raster-oriented, image fallbacks are still possible,
    # but they are always performed at the native device resolution. So this function has no effect on those backends.
    #
    # NOTE: The fallback resolution only takes effect at the time of completing a page
    # (with `Context#show_page` or `Context#copy_page`) so there is currently no way to
    # have more than one fallback resolution in effect on a single page.
    #
    # The default fallback resoultion is 300 pixels per inch in both dimensions.
    #
    # ###Parameters
    # - **res.x** horizontal setting for pixels per inch
    # - **res.y** vertical setting for pixels per inch
    def fallback_resolution=(res : Point)
      LibCairo.surface_set_fallback_resolution(@surface, res.x, res.y)
      self
    end

    # Emits the current page for backends that support multiple pages, but doesn't clear it,
    # so that the contents of the current page will be retained for the next page.
    # Use `Surface#show_page` if you want to get an empty page after the emission.
    #
    # There is a convenience function for this that takes a `Context`, namely `Context#copy_page`.
    def copy_page
      LibCairo.surface_copy_page(@surface)
      self
    end

    # Emits and clears the current page for backends that support multiple pages.
    # Use `Surface#copy_page` if you don't want to clear the page.
    #
    # There is a convenience function for this that takes a cairo_t, namely `Context#show_page`.
    def surface_show_page
      LibCairo.surface_show_page(@surface)
      self
    end

    # Returns whether the surface supports sophisticated `Context#show_text_glyphs` operations.
    # That is, whether it actually uses the provided text and cluster data to a `Context#show_text_glyphs` call.
    #
    # NOTE: Even if this function returns `false`, a `Context#show_text_glyphs` operation targeted at surface will
    # still succeed. It just will act like a `Context#show_glyphs` operation.
    # Users can use this function to avoid computing UTF-8 text and cluster mapping if the target surface does not use it.
    #
    # ###Returns
    # `true` if surface supports `Context#show_text_glyphs`, `false` otherwise.
    def has_show_text_glyphs? : Bool
      LibCairo.surface_has_show_text_glyphs(@surface) == 1
    end

    # Get a pointer to the data of the image surface, for direct inspection or
    # modification.
    #
    # A call to `Surface#flush` is required before accessing the pixel data to
    # ensure that all pending drawing operations are finished. A call to
    # `Surface#mark_dirty` is required after the data is modified.
    #
    # ###Returns
    # A pointer to the image data of this surface or `nil` if surface is not
    # an image surface, or if `Surface#finish` has been called.
    def data : UInt8*
      LibCairo.image_surface_get_data(@surface)
    end

    # Get the format of the surface.
    #
    # ###Returns
    # The format of the surface.
    def format : Format
      Format.new(LibCairo.image_surface_get_format(@surface).value)
    end

    # Get the width of the image surface in pixels.
    #
    # ###Returns
    # The width of the surface in pixels.
    def width : Int32
      LibCairo.image_surface_get_width(@surface)
    end

    # Get the height of the image surface in pixels.
    #
    # ###Returns
    # The height of the surface in pixels.
    def height : Int32
      LibCairo.image_surface_get_height(@surface)
    end

    # Get the stride of the image surface in bytes.
    #
    # ###Returns
    # The stride of the image surface in bytes (or 0 if *surface* is not
    # an image surface). The stride is the distance in bytes from the beginning
    # of one row of the image data to the beginning of the next row.
    def stride : Int32
      LibCairo.image_surface_get_stride(@surface)
    end

    {% if Cairo::C::HAS_RECORDING_SURFACE %}

    # Measures the extents of the operations stored within the recording-surface.
    # This is useful to compute the required size of an image surface
    # (or equivalent) into which to replay the full sequence of drawing operations.
    #
    # ###Returns
    # A `Rectangle` of ink bounding-box.
    def ink_extents : Rectangle
      LibCairo.recording_surface_ink_extents(@surface, out x0, out y0, out width, out height)
      Rectangle.new(x1, y1, width, height)
    end

    # Get the extents of the recording-surface.
    #
    # ###Returns
    # - **extents** the `Rectangle` to be assigned the extents
    # - **bounded** `true` if the surface is bounded,
    # of recording type, and not in an error state, otherwise `false`
    def extents : NamedTuple(extents: Rectangle, bounded: Bool)
      bounded = LibCairo.recording_surface_get_extents(@surface, out extents) == 1
      {extents: extents, bounded: bounded}
    end

    {% end %}

    def to_unsafe : LibCairo::PSurfaceT
      @surface
    end
  end
end
