require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # `Pattern` is the paint with which cairo draws. The primary use of patterns is as the source for all cairo drawing operations,
  # although they can also be used as masks, that is, as the brush too.
  class Pattern
    def initialize(pattern : LibCairo::PPatternT)
      raise ArgumentError.new("'pattern' cannot be null") if pattern.null?
      @pattern = pattern
    end

    # Decreases the reference count on pattern by one. If the result is zero, then pattern and all associated resources are freed.
    # See `Pattern#reference`.
    def finalize
      LibCairo.pattern_destroy(@pattern)
    end

    # Creates a new user pattern for providing pixel data.
    #
    # Use the setter functions to associate callbacks with the returned pattern. The only mandatory callback is acquire.
    #
    # ###Parameters
    # - **user_data** the user data to be passed to all callbacks
    # - **content** content type for the pixel data that will be returned.
    # Knowing the content type ahead of time is used for analysing the operation and picking the appropriate rendering path.
    # - **width** maximum size of the sample area
    # - **height** maximum size of the sample area
    #
    # ###Returns
    # A newly created `Pattern`. Free with `Pattern#finalize` when you are done using it.
    def self.create_raster_source(user_data : Void*, content : Content, width : Int32, height : Int32) : Pattern
      Pattern.new(LibCairo.pattern_create_raster_source(user_data,
        LibCairo::ContentT.new(content.value), width, height))
    end

    # Creates a new `Pattern` corresponding to an opaque color. The color components are floating point numbers in the range *0* to *1*.
    # If the values passed in are outside that range, they will be clamped.
    #
    # ###Parameters
    # - **red** red component of the color
    # - **green** green component of the color
    # - **blue** blue component of the color
    #
    # ###Returns
    #
    # The newly created `Pattern` if successful, or an error pattern in case of no memory.
    # The caller owns the returned object and should call `Pattern#finalize` when finished with it.
    def self.create_rgb(red : Float64, green : Float64, blue : Float64) : Pattern
      Pattern.new(LibCairo.pattern_create_rgb(red, green, blue))
    end

    # Creates a new `Pattern` corresponding to a translucent color. The color components are floating point numbers in the range *0* to *1*-
    # If the values passed in are outside that range, they will be clamped.
    #
    # ###Parameters
    # - **red** red component of the color
    # - **green** green component of the color
    # - **blue** blue component of the color
    # - **alpha** alpha component of the color
    #
    # ###Returns
    # The newly created `Pattern` if successful, or an error pattern in case of no memory.
    # The caller owns the returned object and should call `Pattern#finalize` when finished with it.
    def create_rgba(red : Float64, green : Float64, blue : Float64, alpha : Float64) : Pattern
      Pattern.new(LibCairo.pattern_create_rgb(red, green, blue, alpha))
    end

    # Create a new `Pattern` for the given surface.
    #
    # ###Parameters
    # - **surface** the surface
    #
    # ###Returns
    # The newly created `Pattern` if successful, or an error pattern in case of no memory.
    # The caller owns the returned object and should call `Pattern#finalize` when finished with it.
    #
    # This function will always return a valid `Pattern`, but if an error occurred the pattern status will be set to an error.
    # To inspect the status of a pattern use `Pattern#status`.
    def self.create_for_surface(surface : Surface) : Pattern
      Pattern.new(LibCairo.pattern_create_for_surface(surface.to_unsafe))
    end

    # Create a new linear gradient `Pattern` along the line defined by *(x0, y0)* and *(x1, y1)*.
    # Before using the gradient pattern, a number of color stops should be defined
    # using `Pattern#add_color_stop`.
    #
    # NOTE: The coordinates here are in pattern space. For a new pattern, pattern space is identical to user space,
    # but the relationship between the spaces can be changed with `Pattern#matrix=`.
    #
    # ###Parameters
    # - **x0** x coordinate of the start point
    # - **y0** y coordinate of the start point
    # - **x1** x coordinate of the end point
    # - **y1** y coordinate of the end point
    #
    # ###Returns
    # The newly created `Pattern` if successful, or an error pattern in case of no memory.
    # The caller owns the returned object and should call `Pattern#finalize` when finished with it.
    #
    # This function will always return a valid pointer, but if an error occurred the pattern status will be set to an error.
    # To inspect the status of a pattern use `Pattern#status`.
    def self.create_linear(x0 : Float64, y0 : Float64, x1 : Float64, y1 : Float64) : Pattern
      Pattern.new(LibCairo.pattern_create_linear(x0, y0, x1, y1))
    end

    # Creates a new radial gradient `Pattern` between the two circles defined by *(cx0, cy0, radius0)* and *(cx1, cy1, radius1)*.
    # Before using the gradient pattern, a number of color stops should be defined using `Pattern#add_color_stop`.
    #
    # NOTE: The coordinates here are in pattern space. For a new pattern, pattern space is identical to user space,
    # but the relationship between the spaces can be changed with `Pattern#matrix=`.
    #
    # ###Parameters
    # - **cx0** x coordinate for the center of the start circle
    # - **cy0** y coordinate for the center of the start circle
    # - **radius0** radius of the start circle
    # - **cx1** x coordinate for the center of the end circle
    # - **cy1** y coordinate for the center of the end circle
    # - **radius1** radius of the end circle
    #
    # ###Returns
    #
    # The newly created `Pattern` if successful, or an error pattern in case of no memory.
    # The caller owns the returned object and should call `Pattern#finalize` when finished with it.
    #
    # This function will always return a valid pointer, but if an error occurred the pattern status will be set to an error.
    # To inspect the status of a pattern use `Pattern#status`.
    def self.create_radial(cx0 : Float64, cy0 : Float64, radius0 : Float64, cx1 : Float64, cy1 : Float64, radius1 : Float64) : Pattern
      Pattern.new(LibCairo.pattern_create_radial(cx0, cy0, radius0, cx1, cy1, radius1))
    end

    # Create a new mesh pattern.
    #
    # Mesh patterns are tensor-product patch meshes (type 7 shadings in PDF).
    # Mesh patterns may also be used to create other types of shadings that are special cases of
    # tensor-product patch meshes such as Coons patch meshes (type 6 shading in PDF) and
    # Gouraud-shaded triangle meshes (type 4 and 5 shadings in PDF).
    #
    # Mesh patterns consist of one or more tensor-product patches, which should be defined before using the mesh pattern.
    # Using a mesh pattern with a partially defined patch as source or mask will put the context in an error status with
    # a status of `Status::InvalidMeshConstruction`.
    #
    # A tensor-product patch is defined by 4 Bézier curves (side 0, 1, 2, 3) and by 4 additional control points (P0, P1, P2, P3)
    # that provide further control over the patch and complete the definition of the tensor-product patch.
    # The corner C0 is the first point of the patch.
    #
    # Degenerate sides are permitted so straight lines may be used. A zero length line on one side may be used to create 3 sided patches.
    # ```text
    #     C1       Side 1      C2
    #        +---------------+
    #        |               |
    #        |  P1       P2  |
    #        |               |
    # Side 0 |               | Side 2
    #        |               |
    #        |               |
    #        |  P0       P3  |
    #        |               |
    #        +---------------+
    #     C0       Side 3      C3
    # ```
    # Each patch is constructed by first calling `Pattern#begin_patch`, then `Pattern#move_to` to specify the first point in the patch (C0).
    # Then the sides are specified with calls to `Pattern#curve_to` and `Pattern#line_to`.
    #
    # The four additional control points (P0, P1, P2, P3) in a patch can be specified with `Pattern#set_control_point`.
    #
    # At each corner of the patch (C0, C1, C2, C3) a color may be specified with `Pattern#set_corner_color_rgb` or `Pattern#set_corner_color_rgba`.
    # Any corner whose color is not explicitly specified defaults to transparent black.
    #
    # A Coons patch is a special case of the tensor-product patch where the control points are implicitly defined by the sides of the patch.
    # The default value for any control point not specified is the implicit value for a Coons patch,
    # i.e. if no control points are specified the patch is a Coons patch.
    #
    # A triangle is a special case of the tensor-product patch where the control points are implicitly defined by the sides of the patch,
    # all the sides are lines and one of them has length 0, i.e. if the patch is specified using just 3 lines, it is a triangle.
    # If the corners connected by the 0-length side have the same color, the patch is a Gouraud-shaded triangle.
    #
    # Patches may be oriented differently to the above diagram. For example the first point could be at the top left.
    # The diagram only shows the relationship between the sides, corners and control points. Regardless of where the first point is located,
    # when specifying colors, corner 0 will always be the first point, corner 1 the point between side 0 and side 1 etc.
    #
    # Calling `Pattern#end_patch` completes the current patch. If less than 4 sides have been defined,
    # the first missing side is defined as a line from the current point to the first point of the patch (C0)
    # and the other sides are degenerate lines from C0 to C0. The corners between the added sides will all be coincident
    # with C0 of the patch and their color will be set to be the same as the color of C0.
    #
    # Additional patches may be added with additional calls to `Pattern#begin_patch`/`Pattern#end_patch`.
    # ```
    # pattern = Pattern.create_mesh
    #
	  # # Add a Coons patch
    # pattern
    #   .begin_patch
	  #   .move_to(0, 0)
	  #   .curve_to(30, -30,  60,  30, 100, 0)
	  #   .curve_to(60,  30, 130,  60, 100, 100)
	  #   .curve_to(60,  70,  30, 130,   0, 100)
	  #   .curve_to(30,  70, -30,  30,   0, 0)
	  #   .set_corner_color(0, 1, 0, 0)
	  #   .set_corner_color(1, 0, 1, 0)
	  #   .set_corner_color(2, 0, 0, 1)
	  #   .set_corner_color(3, 1, 1, 0)
	  #   .end_patch
    #
	  # # Add a Gouraud-shaded triangle
    # pattern
    #   .begin_patch
	  #   .move_to(100, 100)
	  #   .line_to(130, 130)
	  #   .line_to(130,  70)
	  #   .set_corner_color(0, 1, 0, 0)
	  #   .set_corner_color(1, 0, 1, 0)
	  #   .set_corner_color(2, 0, 0, 1)
    #   .end_patch
    # ```
    #
    # When two patches overlap, the last one that has been added is drawn over the first one.
    #
    # When a patch folds over itself, points are sorted depending on their parameter coordinates inside the patch.
    # The *v* coordinate ranges from 0 to 1 when moving from side 3 to side 1; the *u* coordinate ranges from 0 to 1 when going from side 0 to side 1.
    #
    # Points with higher *v* coordinate hide points with lower *v* coordinate. When two points have the same *v* coordinate,
    # the one with higher *u* coordinate is above. This means that points nearer to side 1 are above points nearer to side 3;
    # when this is not sufficient to decide which point is above (for example when both points belong to side 1 or side 3)
    # points nearer to side 2 are above points nearer to side 0.
    #
    # For a complete definition of tensor-product patches, see the PDF specification (ISO32000), which describes the parametrization in detail.
    #
    # NOTE: The coordinates are always in pattern space. For a new pattern, pattern space is identical to user space,
    # but the relationship between the spaces can be changed with `Pattern#matrix=`.
    #
    # ###Returns
    # The newly created `Pattern` if successful, or an error pattern in case of no memory.
    # The caller owns the returned object and should call `Pattern#finalize` when finished with it.
    #
    # This function will always return a valid pointer, but if an error occurred the pattern status will be set to an error.
    # To inspect the status of a pattern use `Pattern#status`.
    def self.create_mesh : Pattern
      Pattern.new(LibCairo.pattern_create_mesh)
    end

    # Queries the current user data.
    #
    # ###Returns
    # The current user-data passed to each callback.
    def callback_data : Void*
      LibCairo.raster_source_pattern_get_callback_data(@pattern)
    end

    # Updates the user data that is provided to all callbacks.
    #
    # ###Parameters
    # - **data** the user data to be passed to all callbacks
    def callback_data=(data : Void*)
      LibCairo.raster_source_pattern_set_callback_data(@pattern, data)
      self
    end

    # Queries the current acquire and release callbacks.
    #
    # ###Returns
    # - **acquire** the current acquire callback
    # - **release** the current release callback
    def acquire : NamedTuple(acquire: LibCairo::RasterSourceAcquireFuncT, release: LibCairo::RasterSourceReleaseFuncT)
      LibCairo.raster_source_pattern_get_acquire(@pattern, out acquire, out release)
      {acquire: acquire, release: release}
    end

    # Specifies the callbacks used to generate the image surface for a rendering operation (acquire)
    # and the function used to cleanup that surface afterwards.
    #
    # The acquire callback should create a surface (preferably an image surface created to match
    # the target using `Surface#create_similar_image`) that defines at least the region of interest
    # specified by extents. The surface is allowed to be the entire sample area, but if it does contain
    # a subsection of the sample area, the surface extents should be provided by setting the device offset
    # (along with its width and height) using `Surface#set_device_offset`.
    #
    # ###Parameters
    # - **acquire** acquire callback
    # - **release** release callback
    def set_acquire(acquire : LibCairo::RasterSourceAcquireFuncT, release : LibCairo::RasterSourceReleaseFuncT)
      LibCairo.raster_source_pattern_set_acquire(@pattern, acquire, release)
      self
    end

    # Queries the current snapshot callback.
    #
    # ###Returns
    # The current snapshot callback.
    def snapshot : LibCairo::RasterSourceSnapshotFuncT
      LibCairo.raster_source_pattern_get_snapshot(@pattern)
    end

    # Sets the callback that will be used whenever a snapshot is taken of the pattern,
    # that is whenever the current contents of the pattern should be preserved for later use.
    # This is typically invoked whilst printing.
    #
    # ###Parameters
    # - **snapshot** snapshot callback
    def snapshot=(snapshot : LibCairo::RasterSourceSnapshotFuncT)
      LibCairo.raster_source_pattern_set_snapshot(@pattern, snapshot)
      self
    end

    # Queries the current copy callback.
    #
    # ###Returns
    # The current copy callback.
    def copy : LibCairo::RasterSourceCopyFuncT
      LibCairo.raster_source_pattern_get_copy(@pattern)
    end

    # Updates the copy callback which is used whenever a temporary copy of the pattern is taken.
    #
    # ###Parameters
    # - **copy** the copy callback
    def copy=(copy : LibCairo::RasterSourceCopyFuncT)
      LibCairo.raster_source_pattern_set_copy(@pattern, copy)
      self
    end

    # Queries the current finish callback.
    #
    # ##Returns
    # The current finish callback.
    def finish : LibCairo::RasterSourceFinishFuncT
      LibCairo.raster_source_pattern_get_finish(@pattern)
    end

    # Updates the finish callback which is used whenever a pattern (or a copy thereof) will no longer be used.
    #
    # ###Parameters
    # - **finish** the finish callback
    def finish=(finish : LibCairo::RasterSourceFinishFuncT)
      LibCairo.raster_source_pattern_set_finish(@pattern, finish)
      self
    end

    # Increases the reference count on pattern by one.
    # This prevents pattern from being destroyed until a matching call to `Pattern#finalize` is made.
    #
    # Use `Pattern#reference_count` to get the number of references to a `Pattern`.
    #
    # ###Returns
    # The referenced `Pattern`.
    def reference : Pattern
      Pattern.new(LibCairo.pattern_reference(@pattern))
    end

    # Returns the current reference count of pattern .
    def reference_count : UInt32
      LibCairo.pattern_get_reference_count(@pattern)
    end

    # Checks whether an error has previously occurred for this pattern.
    #
    # ###Returns
    # `Status::Success`, `Status::NoMemory`, `Status::InvalidMatrix`, `Status::PatternTypeMismatch`, or `Status::InvalidMeshConstruction`.
    def status : Status
      Status.new(LibCairo.pattern_status(@pattern).value)
    end

    # Return user data previously attached to pattern using the specified key.
    # If no user data has been attached with the given key this function returns Nil.
    #
    # ###Parameters
    # - **key** the address of the `UserDataKey` the user data was attached to
    #
    # ###Returns
    # The user data previously attached or Nil.
    def user_data(key : UserDataKey) : Void*
      LibCairo.pattern_get_user_data(@pattern, key.to_unsafe)
    end

    # Attach user data to pattern. To remove user data from a surface, call this function with the key that was used to set it and Nil for data.
    #
    # ###Parameters
    # - **key** the address of a `UserDataKey` to attach the user data to
    # - **user_data** the user data to attach to the `Pattern`
    # - **destroy** a `LibCairo::DestroyFuncT` which will be called when the `Context` is destroyed
    # or when new user data is attached using the same key.
    #
    # ###Returns
    # `Status::Success` or `Status::NoMemory` if a slot could not be allocated for the user data.
    def set_user_data(key : UserDataKey, user_data : Void*, destroy : LibCairo::DestroyFuncT) : Status
      Status.new(LibCairo.pattern_set_user_data(@pattern, key.to_unsafe, user_data, destroy).value)
    end

    # Get the pattern's type. See `PatternType` for available types.
    def type : PatternType
      PatternType.new(LibCairo.pattern_get_type(@pattern))
    end

    # Adds an opaque color stop to a gradient pattern. The offset specifies the location along the gradient's control vector.
    # For example, a linear gradient's control vector is from *(x0, y0)* to *(x1, y1)* while a radial gradient's control
    # vector is from any point on the start circle to the corresponding point on the end circle.
    #
    # The color is specified in the same way as in `Context#set_source_rgb`.
    #
    # If two (or more) stops are specified with identical offset values, they will be sorted according to the order
    # in which the stops are added, (stops added earlier will compare less than stops added later).
    # This can be useful for reliably making sharp color transitions instead of the typical blend.
    #
    # NOTE: If the pattern is not a gradient pattern, (eg. a linear or radial pattern),
    # then the pattern will be put into an error status with a status of `Status::PatternTypeMismatch`.
    #
    # ###Parameters
    # - **offset** an offset in the range [0.0 .. 1.0]
    # - **red** red component of color
    # - **green** green component of color
    # - **blue** blue component of color
    def add_color_stop(offset : Float64, red : Float64, green : Float64, blue : Float64)
      LibCairo.pattern_add_color_stop_rgb(@pattern, offset, red, green, blue)
      self
    end

    # Adds a translucent color stop to a gradient pattern. The offset specifies the location along the gradient's control vector.
    # For example, a linear gradient's control vector is from *(x0, y0)* to *(x1, y1)* while a radial gradient's
    # control vector is from any point on the start circle to the corresponding point on the end circle.
    #
    # The color is specified in the same way as in `Context#set_source_rgba`.
    #
    # If two (or more) stops are specified with identical offset values, they will be sorted according to the order in which the stops are added,
    # (stops added earlier will compare less than stops added later). This can be useful for reliably making sharp color transitions
    # instead of the typical blend.
    #
    # NOTE: If the pattern is not a gradient pattern, (eg. a linear or radial pattern), then the pattern will be put into an
    # error status with a status of `Status::PatternTypeMismatch`.
    #
    # ###Parameters
    # - **offset** an offset in the range [0.0 .. 1.0]
    # - **red** red component of color
    # - **green** green component of color
    # - **blue** blue component of color
    # - **alpha** alpha component of color
    def add_color_stop(offset : Float64, red : Float64, green : Float64, blue : Float64, alpha : Float64)
      LibCairo.pattern_add_color_stop_rgba(@pattern, offset, red, green, blue, alpha)
      self
    end

    # Begin a patch in a mesh pattern.
    #
    # After calling this function, the patch shape should be defined with `Pattern#move_to`, `Pattern#line_to` and `Pattern#curve_to`.
    #
    # After defining the patch, `Pattern#end_patch` must be called before using pattern as a source or mask.
    #
    # NOTE: If pattern is not a mesh pattern then pattern will be put into an error status with a status
    # of `Status::PatternTypeMismatch`. If pattern already has a current patch, it will be put into an error status
    # with a status of `Status::InvalidMeshConstruction`.
    def begin_patch
      LibCairo.mesh_pattern_begin_patch(@pattern)
      self
    end

    # Indicates the end of the current patch in a mesh pattern.
    #
    # If the current patch has less than 4 sides, it is closed with a straight line from the current point to
    # the first point of the patch as if `Pattern#line_to` was used.
    #
    # NOTE: If pattern is not a mesh pattern then pattern will be put into an error status with a status
    # of `Status::PatternTypeMismatch`. If pattern has no current patch or the current patch has no current point,
    # pattern will be put into an error status with a status of `Status::InvalidMeshConstruction`.
    def end_patch
      LibCairo.mesh_pattern_end_patch(@pattern)
      self
    end

    # Adds a cubic Bézier spline to the current patch from the current point to position *(x3, y3)* in pattern-space coordinates,
    # using *(x1, y1)* and *(x2, y2)* as the control points.
    #
    # If the current patch has no current point before the call to `Pattern#curve_to`,
    # this function will behave as if preceded by a call to `Pattern#move_to`.
    #
    # After this call the current point will be *(x3, y3)*.
    #
    # NOTE: If pattern is not a mesh pattern then pattern will be put into an error status with a status
    # of `Status::PatternTypeMismatch`. If pattern has no current patch or the current patch already has 4 sides,
    # pattern will be put into an error status with a status of `Status::InvalidMeshConstruction`.
    #
    # ###Parameters
    # - **x1** the X coordinate of the first control point
    # - **y1** the Y coordinate of the first control point
    # - **x2** the X coordinate of the second control point
    # - **y2** the Y coordinate of the second control point
    # - **x3** the X coordinate of the end of the curve
    # - **y3** the Y coordinate of the end of the curve
    def curve_to(x1 : Float64, y1 : Float64, x2 : Float64, y2 : Float64, x3 : Float64, y3 : Float64)
      LibCairo.mesh_pattern_curve_to(@pattern, x1, y1, x2, y2, x3, y3)
      self
    end

    # Adds a line to the current patch from the current point to position *(x, y)* in pattern-space coordinates.
    #
    # If there is no current point before the call to `Pattern#line_to` this function will behave as `Pattern#move_to`.
    #
    # After this call the current point will be *(x, y)*.
    #
    # NOTE: If pattern is not a mesh pattern then pattern will be put into an error status with a status
    # of `Status::PatternTypeMismatch`. If pattern has no current patch or the current patch already has 4 sides,
    # pattern will be put into an error status with a status of `Status::InvalidMeshConstruction`.
    #
    # ###Parameters
    # - **x** the X coordinate of the end of the new line
    # - **y** the Y coordinate of the end of the new line
    def line_to(x : Float64, y : Float64)
      LibCairo.mesh_pattern_line_to(@pattern, x, y)
      self
    end

    # Define the first point of the current patch in a mesh pattern.
    #
    # After this call the current point will be *(x, y)*.
    #
    # NOTE: If pattern is not a mesh pattern then pattern will be put into an error status with a status
    # of `Status::PatternTypeMismatch`. If pattern has no current patch or the current patch already has at least one side,
    # pattern will be put into an error status with a status of `Status::InvalidMeshConstruction`.
    #
    # ###Parameters
    # - **x** the X coordinate of the new position
    # - **y** the Y coordinate of the new position
    def move_to(x : Float64, y : Float64)
      LibCairo.mesh_pattern_move_to(@pattern, x, y)
      self
    end

    # Set an internal control point of the current patch.
    #
    # Valid values for *point_num* are from 0 to 3 and identify the control points as explained in `Pattern#create_mesh`.
    #
    # NOTE: If pattern is not a mesh pattern then pattern will be put into an error status with a status
    # of `Status::PatternTypeMismatch`. If *point_num* is not valid, pattern will be put into an error status with a status
    # of `Status::InvalidIndex`. If pattern has no current patch, pattern will be put into an error status with a status
    # of `Status::InvalidMeshConstruction`.
    #
    # ###Parameters
    # - **point_num** the control point to set the position for
    # - **x** the X coordinate of the control point
    # - **y** the Y coordinate of the control point
    def set_control_point(point_num : UInt32, x : Float64, y : Float64)
      LibCairo.mesh_pattern_set_control_point(@pattern, point_num, x, y)
      self
    end

    # Sets the color of a corner of the current patch in a mesh pattern.
    #
    # The color is specified in the same way as in `Context#source=`.
    #
    # Valid values for *corner_num* are from 0 to 3 and identify the corners as explained in `Pattern#create_mesh`.
    #
    # NOTE: If pattern is not a mesh pattern then pattern will be put into an error status with a status of
    # `Status::PatternTypeMismatch`. If *corner_num* is not valid, pattern will be put into an error status with
    # a status of `Status::InvalidIndex`. If pattern has no current patch, pattern will be put into an error
    # status with a status of `Status::InvalidMeshConstruction`.
    #
    # ###Parameters
    # - **corner_num** the corner to set the color for
    # - **red** red component of color
    # - **green** green component of color
    # - **blue** blue component of color
    def set_corner_color(corner_num : UInt32, red : Float64, green : Float64, blue : Float64)
      LibCairo.mesh_pattern_set_corner_color_rgb(@pattern, corner_num, red, green, blue)
      self
    end

    # Sets the color of a corner of the current patch in a mesh pattern.
    #
    # The color is specified in the same way as in `Context#source=`.
    #
    # Valid values for *corner_num* are from 0 to 3 and identify the corners as explained in `Pattern#create_mesh`.
    #
    # NOTE: If pattern is not a mesh pattern then pattern will be put into an error status with a status of
    # `Status::PatternTypeMismatch`. If *corner_num* is not valid, pattern will be put into an error status with
    # a status of `Status::InvalidIndex`. If pattern has no current patch, pattern will be put into an error status
    # with a status of `Status::InvalidMeshConstruction`.
    #
    # ###Parameters
    # - **corner_num** the corner to set the color for
    # - **red** red component of color
    # - **green** green component of color
    # - **blue** blue component of color
    # - **alpha** alpha component of color
    def set_corner_color_rgba(corner_num : UInt32, red : Float64, green : Float64, blue : Float64, alpha : Float64)
      LibCairo.mesh_pattern_set_corner_color_rgba(@pattern, corner_num, red, green, blue, alpha)
      self
    end

    # Returns the pattern's transformation matrix.
    def matrix : Matrix
      matrix = Matrix.new
      LibCairo.pattern_get_matrix(@pattern, matrix.to_unsafe)
      matrix
    end

    # Sets the pattern's transformation matrix to matrix.
    # This matrix is a transformation from user space to pattern space.
    #
    # When a pattern is first created it always has the identity matrix for its transformation matrix,
    # which means that pattern space is initially identical to user space.
    #
    # Important: Please NOTE that the direction of this transformation matrix is from user space to pattern space.
    # This means that if you imagine the flow from a pattern to user space (and on to device space),
    # then coordinates in that flow will be transformed by the inverse of the pattern matrix.
    #
    # For example, if you want to make a pattern appear twice as large as it does by default the correct code to use is:
    # ```
    # matrix.init_scale(0.5, 0.5)
    # pattern.matrix = matrix
    # ```
    #
    # Meanwhile, using values of 2.0 rather than 0.5 in the code above would cause the pattern to appear at half of its default size.
    #
    # Also, please note the discussion of the user-space locking semantics of `Context#source=`.
    #
    # ###Parameters
    # - **matrix** a `Matrix`
    def matrix=(matrix : Matrix)
      LibCairo.pattern_set_matrix(@pattern, matrix.to_unsafe)
      self
    end

    # Gets the current extend mode for a pattern. See `Extend` for details on the semantics of each extend strategy.
    #
    # ###Returns
    # The current extend strategy used for drawing the pattern.
    def extend : Extend
      Extend.new(LibCairo.pattern_get_extend(@pattern).value)
    end

    # Sets the mode to be used for drawing outside the area of a pattern.
    # See `Extend` for details on the semantics of each extend strategy.
    #
    # The default extend mode is `Extend::None` for surface patterns and `Extend::Pad` for gradient patterns.
    #
    # ###Parameters
    # - **ex** a `Extend` describing how the area outside of the pattern will be drawn
    def extend=(ex : Extend)
      LibCairo.pattern_set_extend(@pattern, LibCairo::ExtendT.new(ex.value))
      self
    end

    # Gets the current filter for a pattern. See `Filter` for details on each filter.
    #
    # ###Returns
    # The current filter used for resizing the pattern.
    def filter : Filter
      Filter.new(LibCairo.pattern_get_filter(@pattern).value)
    end

    # Sets the filter to be used for resizing when using this pattern. See `Filter` for details on each filter.
    #
    # NOTE that you might want to control filtering even when you do not have an explicit `Pattern` object,
    # (for example when using `Context#set_source_surface`). In these cases, it is convenient to use `Context#get_source`
    # to get access to the pattern that cairo creates implicitly. For example:
    # ```
    # context.set_source_surface(image, x, y)
    # context.source.filter = Filter::Nearest
    # ```
    #
    # ###Parameters
    # - **filter** a `Filter` describing the filter to use for resizing the pattern
    def filter=(filter : Filter)
      LibCairo.pattern_set_filter(@pattern, LibCairo::FilterT.new(filter.value))
      self
    end

    # Gets the solid color for a solid color pattern.
    #
    # ###Returns
    # `RGBA` structure.
    #
    # ###Raises
    # `StatusException` with *status* of `Status::PatternTypeMismatch` if the pattern is not a solid color pattern.
    def rgba : RGBA
      status = Status.new(LibCairo.pattern_get_rgba(@pattern, out red, out green, out blue, out alpha).value)
      raise StatusException.new(status) unless status.success?
      RGBA.new(red, green, blue, alpha)
    end

    # Gets the surface of a surface pattern. The reference returned in surface is owned by the pattern;
    # the caller should call `Surface#reference` if the surface is to be retained.
    #
    # ###Returns
    # `Surface` object.
    #
    # ###Raises
    # `StatusException` with *status* of `Status::PatternTypeMismatch` if the pattern is not a surface pattern.
    def surface : Surface
      status = Status.new(LibCairo.pattern_get_surface(@pattern, out surface).value)
      raise StatusException.new(status) unless status.success?
      Surface.new(surface)
    end

    # Gets the color and offset information at the given index for a gradient pattern.
    # Values of index range from *0* to *n-1* where *n* is the number returned by `Pattern#color_stop_count`.
    #
    # ###Parameters
    # - **index** index of the stop to return data for
    #
    # ###Returns
    # `ColorStop` object.
    #
    # ###Raises
    # - `StatusException` whith *status* of `Status::InvalidIndex` if index is not valid for the given pattern.
    #    If the pattern is not a gradient pattern, *status* is `Status::PatternTypeMismatch`.
    def color_stop(index : Int32) : ColorStop
      status = Status.new(LibCairo.pattern_get_color_stop_rgba(@pattern,
        index, out offset, out red, out green, out blue, out alpha).value)
      raise StatusException.new(status) unless status.success?
      ColorStop.new(offset, red, green, blue, alpha)
    end

    # Gets the number of color stops specified in the given gradient pattern.
    #
    # ###Returns
    # The number of color stops.
    #
    # ###Raises
    # - `StatusException` with *status* of `Status::PatternTypeMismatch` if pattern is not a gradient pattern.
    def color_stop_count : Int32
      status = Status.new(pattern_get_color_stop_count(@pattern, out count).value)
      raise StatusException.new(status) unless status.success?
      count
    end

    # Gets the gradient endpoints for a linear gradient.
    #
    # ###Returns
    # - **x0** return value for the x coordinate of the first point
    # - **y0** return value for the y coordinate of the first point
    # - **x1** return value for the x coordinate of the second point
    # - **y1** return value for the y coordinate of the second point
    #
    # ###Raises
    # - `StatusException` with *status* of `Status::PatternTypeMismatch` if pattern is not a linear gradient pattern.
    def linear_points : NamedTuple(x0: Float64, y0: Float64, x1: Float64, y1: Float64)
      status = Status.new(LibCairo.pattern_get_linear_points(@pattern,
        out x0, out y0, out x1, out y1).value)
      raise StatusException.new(status) unless status.success?
      {x0: x0, y0: y0, x1: x1, y1: y1}
    end

    # Gets the gradient endpoint circles for a radial gradient, each specified as a center coordinate and a radius.
    #
    # ###Returns
    # - **x0** return value for the x coordinate of the center of the first circle
    # - **y0** return value for the y coordinate of the center of the first circle
    # - **r0** return value for the radius of the first circle
    # - **x1** return value for the x coordinate of the center of the second circle
    # - **y1** return value for the y coordinate of the center of the second circle
    # - **r1** return value for the radius of the second circle
    #
    # ###Raises
    # - `StatusException` with *status* of `Status::PatternTypeMismatch` if pattern is not a radial gradient pattern.
    def radial_circles : NamedTuple(x0: Float64, y0: Float64, r0: Float64, x1: Float64, y1: Float64, r1: Float64)
      status = Status.new(LibCairo.pattern_get_radial_circles(@pattern,
        out x0, out y0, out r0, out x1, out y1, out r1).value)
      raise StatusException.new(status) unless status.success?
      {x0: x0, y0: y0, r0: r0, x1: x1, y1: y1, r1: r1}
    end

    # Gets the number of patches specified in the given mesh pattern.
    #
    # The number only includes patches which have been finished by calling `Pattern#end_patch`.
    # For example it will be 0 during the definition of the first patch.
    #
    # ###Returns
    # The number patches
    #
    # ###Raises
    # - `StatusException` with *status* of `Status::PatternTypeMismatch` if pattern is not a mesh pattern.
    def patch_count : UInt32
      status = Status.new(LibCairo.mesh_pattern_get_patch_count(@pattern, out count).value)
      raise StatusException.new(status) unless status.success?
      count
    end

    # Gets path defining the patch *patch_num* for a mesh pattern.
    #
    # *patch_num* can range from 0 to n-1 where n is the number returned by `Pattern#patch_count`.
    #
    # ###Parameters
    # - **patch_num** the patch number to return data for
    #
    # ###Returns
    # The path defining the patch, or a path with status `Status::InvalidIndex` if *patch_num* or *point_num* is not valid for pattern.
    # If pattern is not a mesh pattern, a path with status `Status::PatternTypeMismatch` is returned.
    def path(patch_num : UInt32) : Path
      Path.new(LibCairo.mesh_pattern_get_path(@pattern, patch_num))
    end

    # Gets the color information in corner *corner_num* of patch *patch_num* for a mesh pattern.
    #
    # *patch_num* can range from *0* to *n-1* where *n* is the number returned by `Pattern#patch_count`.
    #
    # Valid values for *corner_num* are from *0* to *3* and identify the corners as explained in `Pattern#create_mesh`.
    #
    # ###Parameters
    # - **patch_num** the patch number to return data for
    # - **corner_num** the corner number to return data for
    #
    # ###Returns
    # The color structure.
    #
    # ###Raises
    # `StatusException` with *status* of `Status::InvalidIndex` if *patch_num* or *corner_num* is not valid for pattern.
    # If pattern is not a mesh pattern, `Status::PatternTypeMismatch` is returned.
    def corner_color(patch_num : UInt32, corner_num : UInt32) : RGBA
      status = Status.new(LibCairo.mesh_pattern_get_corner_color_rgba(@pattern,
        patch_num, corner_num, out red, out green, out blue, out alpha).value)
      raise StatusException.new(status) unless status.success?
      RGBA.new(red, green, blue, alpha)
    end

    # Gets the control point *point_num* of patch patch_num for a mesh pattern.
    #
    # *patch_num* can range from *0* to *n-1* where *n* is the number returned by `Pattern#patch_count`.
    #
    # Valid values for point_num are from *0* to *3* and identify the control points as explained in `Pattern#create_mesh`.
    #
    # ###Parameters
    # - **patch_num** the patch number to return data for
    # - **point_num** the control point number to return data for
    #
    # ###Returns
    #The control point.
    #
    # ###Raises
    # `StatusException` with *status* of `Status::InvalidIndex` if *patch_num* or *point_num* is not valid for pattern.
    # If pattern is not a mesh pattern, `Status::PatternTypeMismatch` is returned.
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
