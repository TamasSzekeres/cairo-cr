require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # The cairo drawing context.
  #
  # `Context` is the main object used when drawing with cairo. To draw with cairo, you create a `Context`,
  # set the target surface, and drawing options for the `Context`, create shapes with functions like `Context#move_to`
  # and `Context#line_to`, and then draw shapes with `Context#stroke` or `Context#fill`.
  #
  # `Context`'s can be pushed to a stack via `Context#save`. They may then safely be changed, without losing the current state.
  # Use `Context#restore` to restore to the saved state.
  #
  # A `Context` contains the current state of the rendering device, including coordinates of yet to be drawn shapes.
  #
  # Cairo contexts, as `Context` objects are named, are central to cairo and all drawing with cairo is always done to a `Context` object.
  #
  # Memory management of `Context` is done with `Contxt#reference` and `Context#finalize`.
  class Context
    # Creates a new `Context` with all graphics state parameters set to default values and with target as a target surface.
    # The target surface should be constructed with a backend-specific function such as `Surface#initialite`.
    #
    # This function references target, so you can immediately call `Context#finalize` on it
    # if you don't need to maintain a separate reference to it.
    #
    # ###Paremeters
    # - **target** target surface for the context
    #
    # ###Returns
    # A newly allocated `Context` with a reference count of 1. The initial reference count should be released with `Content::finalize`
    # when you are done using the `Context`. This function never returns `Nil`.
    # If memory cannot be allocated, a special `Context` object will be returned on which `Context#status` returns
    # `Status::NoMemory`. If you attempt to target a surface which does not support writing then a `Status::WriteError` will be raised.
    # You can use this object normally, but no drawing will be done.
    def initialize(target : Surface)
      @cairo = LibCairo.create(target.to_unsafe)
    end

    def initialize(cairo : LibCairo::PCairoT)
      raise ArgumentError.new("'cairo' cannot be null") if cairo.null?
      @cairo = cairo
    end

    # Decreases the reference count by one. If the result is zero, then `Context` and all associated resources are freed. See `Context#reference`.
    def finalize
      LibCairo.destroy(@cairo)
    end

    def self.version : Int32
      LibCairo.version
    end

    def self.version_string : String
      String.new LibCairo.version_string
    end

    # Increases the reference count on cr by one. This prevents cr from being destroyed until a matching call to `Context#finalize` is made.
    #
    # Use `Context#reference_count` to get the number of references to a `Context`.
    #
    # ###Returns
    # The referenced `Context`.
    def reference : Context
      Context.new LibCairo.reference(@cairo)
    end

    # Returns the current reference count of *context*.
    #
    # ###Returns
    # The current reference count of *context*. If the object is a nil object, 0 will be returned.
    def reference_count : UInt32
      LibCairo.get_reference_count(@cairo)
    end

    # Return user data previously attached to cr using the specified key.
    # If no user data has been attached with the given key this function returns `Nil`.
    #
    # ###Parameters
    # - **key** the address of the `UserDataKey` the user data was attached to
    #
    # ###Returns
    # The user data previously attached or `Nil`.
    def user_data(key : UserDataKey) : Void*
      LibCairo.get_user_data(@cairo, key.to_unsafe)
    end

    # Attach user data to *context*. To remove user data from a surface, call this function with the key that was used to set it and `Nil` for data.
    #
    # ###Parameters
    # - **key** the address of a cairo_user_data_key_t to attach the user data to
    # - **user_data** the user data to attach to the `Context`
    # - **destroy** a `LibCairo::DestroyFuncT` which will be called when the `Context` is destroyed
    # or when new user data is attached using the same key.
    #
    # ###Returns
    # `Status::Success` or `Status::NoMemory` if a slot could not be allocated for the user data.
    def set_user_data(key : UserDataKey, user_data : Void*, destroy : LibCairo::DestroyFuncT) : Status
      LibCairo.set_user_data(@cairo, key.to_unsafe, user_data, destroy)
      self
    end

    # Makes a copy of the current state and saves it on an internal stack of saved states. When `Context#restore` is called,
    # `Context` will be restored to the saved state. Multiple calls to `Context#save` and `Context#restore` can be nested;
    # each call to `Context#restore` restores the state from the matching paired `Context#save`.
    #
    # It isn't necessary to clear all saved states before a `Context` is freed. If the reference count
    # of a `Context` drops to zero in response to a call to `Context#finalize`, any saved states will be freed along with the `Context`.
    def save
      LibCairo.save(@cairo)
      self
    end

    # Restores `Context` to the state saved by a preceding call to `Context#save` and removes that state from the stack of saved states.
    def restore
      LibCairo.restore(@cairo)
      self
    end

    # Temporarily redirects drawing to an intermediate surface known as a group.
    # The redirection lasts until the group is completed by a call to `Context#pop_group` or `Context#pop_group_to_source`.
    # These calls provide the result of any drawing to the group as a pattern, (either as an explicit object, or set as the source pattern).
    #
    # This group functionality can be convenient for performing intermediate compositing. One common use of a group is to render objects
    # as opaque within the group, (so that they occlude each other), and then blend the result with translucence onto the destination.
    #
    # Groups can be nested arbitrarily deep by making balanced calls to `Context#push_group`/`Context#pop_group`.
    # Each call pushes/pops the new target group onto/from a stack.
    #
    # The `Context#push_group` function calls `Context#save` so that any changes to the graphics state will not be visible outside the group,
    # (the pop_group functions call `Context#restore`).
    #
    # By default the intermediate group will have a content type of `Content::ColorAlpha`.
    # Other content types can be chosen for the group by using `Context#push_group_with_content` instead.
    #
    # As an example, here is how one might fill and stroke a path with translucence, but without any portion of the fill being visible under the stroke:
    # ```
    # context.push_group
    # context.set_source(fill_pattern)
    # context.fill_preserve
    # context.set_source(stroke_pattern)
    # context.stroke
    # context.pop_group_to_source
    # context.paint_with_alpha(alpha)
    # ```
    def push_group
      LibCairo.push_group(@cairo)
      self
    end

    # Temporarily redirects drawing to an intermediate surface known as a group.
    # The redirection lasts until the group is completed by a call to `Context#pop_group` or `Context#pop_group_to_source`.
    # These calls provide the result of any drawing to the group as a pattern, (either as an explicit object, or set as the source pattern).
    #
    # The group will have a content type of content. The ability to control this content type is the only distinction between this function
    # and `Context#push_group` which you should see for a more detailed description of group rendering.
    #
    # ###Parameters
    # - **content** a `Content` indicating the type of group that will be created.
    def push_group_with_content(content : Content)
      LibCairo.push_group_with_content(@cairo, LibCairo::ContentT.new content.value)
      self
    end

    # Terminates the redirection begun by a call to `Context#push_group` or `Context#push_group_with_content`
    # and returns a new pattern containing the results of all drawing operations performed to the group.
    #
    # The `Context#pop_group` function calls `Context#restore`, (balancing a call to `Context#save by the `Context#push_group` function),
    # so that any changes to the graphics state will not be visible outside the group.
    #
    # ###Returns
    # A newly created (surface) pattern containing the results of all drawing operations performed to the group.
    # The caller owns the returned object and should call `Surface#finalize` when finished with it.
    def pop_group : Pattern
      Pattern.new(LibCairo.pop_group(@cairo))
    end

    # Terminates the redirection begun by a call to `Context#push_group` or Context#push_group_with_content`
    # and installs the resulting pattern as the source pattern in the given cairo context.
    #
    # The behavior of this function is equivalent to the sequence of operations:
    # ```
    # group = context.pop_group
    # context.set_source(group)
    # group.finalize
    # ```
    # but is more convenient as their is no need for a variable to store the short-lived pointer to the pattern.
    #
    # The `Context#pop_group` function calls `Context#restore`, (balancing a call to `Context#save` by the `Context#push_group` function),
    # so that any changes to the graphics state will not be visible outside the group.
    def pop_group_to_source : Context
      Context.new(LibCairo.pop_group_to_source(@cairo))
    end

    # Sets the compositing operator to be used for all drawing operations.
    # See `Operator` for details on the semantics of each available compositing operator.
    #
    # The default operator is `Operator::Over`.
    #
    # ###Parameters
    # - **op** a compositing operator, specified as a `Operator`
    def operator=(op : Operator)
      LibCairo.set_operator(@cairo, LibCairo::OperatorT.new op.value)
      self
    end

    # Sets the source pattern within `Context` to source. This pattern will then be used for any subsequent
    # drawing operation until a new source pattern is set.
    #
    # Note: The pattern's transformation matrix will be locked to the user space in effect at the time of `Context#source=`.
    # This means that further modifications of the current transformation matrix will not affect the source pattern.
    # See `Pattern#matrix=`.
    #
    # The default source pattern is a solid pattern that is opaque black,
    # (that is, it is equivalent to `context.set_source_rgb(0.0_f64, 0.0_f64, 0.0_f64)`).
    #
    # ###Parameters
    # - **source** a `Pattern` to be used as the source for subsequent drawing operations.
    def source=(source : Pattern)
      LibCairo.set_source(@cairo, source.to_unsafe)
      self
    end

    # Sets the source pattern within `Context` to an opaque color. This opaque color will then be used for any subsequent
    # drawing operation until a new source pattern is set.
    #
    # The color components are floating point numbers in the range 0 to 1. If the values passed in are outside that range, they will be clamped.
    #
    # The default source pattern is opaque black, (that is, it is equivalent to `context.set_source_rgb(0.0_f64, 0.0_f64, 0.0_f64)).
    #
    # ###Parameters
    # - **red** red component of color
    # - **green** green component of color
    # - **blue** blue component of color
    def set_source_rgb(red : Float64, green : Float64, blue : Float64)
      LibCairo.set_source_rgb(@cairo, red, green, blue)
      self
    end

    # Sets the source pattern within cr to a translucent color. This color will then be used for any subsequent drawing operation
    # until a new source pattern is set.
    #
    # The color and alpha components are floating point numbers in the range 0 to 1.
    # If the values passed in are outside that range, they will be clamped.
    #
    # The default source pattern is opaque black, (that is, it is equivalent `context.set_source_rgba(0.0_f64, 0.0_f64, 0.0_f64, 1.0_f64)).
    #
    # ###Parameters
    # red
    # - **red** component of color
    # - **green** green component of color
    # - **blue** blue component of color
    # - **alpha** alpha component of color
    def set_source_rgba(red : Float64, green : Float64, blue : Float64, alpha : Float64)
      LibCairo.set_source_rgba(@cairo, red, green, blue, alpha)
      self
    end

    # This is a convenience function for creating a pattern from surface and setting it as the source in `Context` with `Context#source=`.
    #
    # The **x** and **y** parameters give the user-space coordinate at which the surface origin should appear.
    # (The surface origin is its upper-left corner before any transformation has been applied.)
    # The **x** and **y** parameters are negated and then set as translation values in the pattern matrix.
    #
    # Other than the initial translation pattern matrix, as described above, all other pattern attributes, (such as its extend mode),
    # are set to the default values as in `Pattern#create_for_surface`. The resulting pattern can be queried with `Context#source`
    # so that these attributes can be modified if desired, (eg. to create a repeating pattern with `Pattern#extend=`).
    #
    # ###Parameters
    # - **surface** a surface to be used to set the source pattern
    # - **x** User-space X coordinate for surface origin
    # - **y** User-space Y coordinate for surface origin
    def set_source_surface(surface : Surface, x : Float64, y : Float64)
      LibCairo.set_source_surface(surface.to_unsafe, x, y)
      self
    end

    # Sets the tolerance used when converting paths into trapezoids.
    # Curved segments of the path will be subdivided until the maximum deviation between the original
    # path and the polygonal approximation is less than tolerance. The default value is 0.1.
    # A larger value will give better performance, a smaller value, better appearance.
    # (Reducing the value from the default value of 0.1 is unlikely to improve appearance significantly.)
    # The accuracy of paths within Cairo is limited by the precision of its internal arithmetic,
    # and the prescribed tolerance is restricted to the smallest representable internal value.
    #
    # ###Parameters
    # - **tolerance** the tolerance, in device units (typically pixels)
    def tolerance=(tolerance : Float64)
      LibCairo.set_tolerance(@cairo, tolerance)
      self
    end

    # Set the antialiasing mode of the rasterizer used for drawing shapes. This value is a hint,
    # and a particular backend may or may not support a particular value. At the current time,
    # no backend supports `Antialias::SubPixel` when drawing shapes.
    #
    # Note that this option does not affect text rendering, instead see `FontOptions#antialias=`.
    #
    # ###Parameters
    # - **antialias** the new antialiasing mode
    def antialias=(antialias : Antialias)
      LibCairo.set_antialias(@cairo, LibCairo::AntialiasT.new antialias.value)
      self
    end

    # Set the current fill rule within the cairo context. The fill rule is used to determine which regions are inside
    # or outside a complex (potentially self-intersecting) path. The current fill rule affects both `Context#fill` and `Context#clip`.
    # See `FillRule` for details on the semantics of each available fill rule.
    #
    # The default fill rule is `FillRule::Winding`.
    #
    # ###Parameters
    # - **fill_rule** a fill rule
    def fill_rule=(fill_rule : FillRule)
      LibCairo.set_fill_rule(@cairo, LibCairo::FillRuleT.new fill_rule.value)
      self
    end

    # Sets the current line width within the cairo context. The line width value specifies the diameter of a pen that is circular in user space,
    # (though device-space pen may be an ellipse in general due to scaling/shear/rotation of the CTM).
    #
    # Note: When the description above refers to user space and CTM it refers to the user space and CTM in effect
    # at the time of the stroking operation, not the user space and CTM in effect at the time of the call to `Context#line_width=`.
    # The simplest usage makes both of these spaces identical. That is, if there is no change to the CTM between
    # a call to `Context#line_width` and the stroking operation, then one can just pass user-space values to `Context#line_width=`
    # and ignore this note.
    #
    # As with the other stroke parameters, the current line width is examined by `Context#stroke`, `Context#stroke_extents`,
    # and `Context#stroke_to_path`, but does not have any effect during path construction.
    #
    # The default line width value is 2.0.
    #
    # ###Parameters
    # - **width** a line width
    def line_width=(width : Float64)
      LibCairo.set_line_width(@cairo, width)
      self
    end

    # Sets the current line cap style within the cairo context.
    # See `LineCap` for details about how the available line cap styles are drawn.
    #
    # As with the other stroke parameters, the current line cap style is examined by `Context#stroke`,
    # `Context#stroke_extents`, and `Context#stroke_to_path`, but does not have any effect during path construction.
    #
    # The default line cap style is `LineCap::Butt`.
    #
    # ###Parameters
    # - **line_cap** a line cap style
    def line_cap=(line_cap : LineCap)
      LibCairo.set_line_cap(@cairo, LibCairo::LineCapT.new line_cap.value)
      self
    end

    # Sets the current line join style within the cairo context. See `LineJoin` for details about how the available line join styles are drawn.
    #
    # As with the other stroke parameters, the current line join style is examined by `Context#stroke`, `Context#stroke_extents`,
    # and `Context#stroke_to_path`, but does not have any effect during path construction.
    #
    # The default line join style is `LineJoin::Miter`.
    #
    # ###Parameters
    # - **line_join** a line join style
    def line_join=(line_join : LineJoin)
      LibCairo.set_line_join(@cairo, LibCairo::LineJoinT.new line_join.value)
      self
    end

    # Sets the dash pattern to be used by `Context#stroke`. A dash pattern is specified by dashes,
    # an array of positive values. Each value provides the length of alternate "on" and "off" portions of the stroke.
    # The offset specifies an offset into the pattern at which the stroke begins.
    #
    # Each "on" segment will have caps applied as if the segment were a separate sub-path. In particular,
    # it is valid to use an "on" length of 0.0 with `LineCap::Round` or `LineCap::Square` in order to distributed dots or squares along a path.
    #
    # Note: The length values are in user-space units as evaluated at the time of stroking.
    # This is not necessarily the same as the user space at the time of `Context#dash`.
    #
    # If `dashes.size` is 0 dashing is disabled.
    #
    # If `dashes.size` is 1 a symmetric pattern is assumed with alternating on
    # and off portions of the size specified by the single value in dashes .
    #
    # If any value in dashes is negative, or if all values are 0, then `Context` will be put into an error state
    # with a status of `Status::InvalidDash`.
    #
    # ###Parameters
    # - **dashes** an array specifying alternate lengths of on and off stroke portions
    # - **offset** an offset into the dash pattern at which the stroke should start
    def set_dash(dashes : Array(Float64), offset : Float64)
      LibCairo.set_dash(@cairo, dashes.to_unsafe, dashes.size, offset)
      self
    end

    # Sets the current miter limit within the cairo context.
    #
    # If the current line join style is set to `LineJoin::Miter` (see `Context#line_join=`),
    # the miter limit is used to determine whether the lines should be joined with a bevel instead of a miter.
    # Cairo divides the length of the miter by the line width. If the result is greater than the miter limit, the style is converted to a bevel.
    #
    # As with the other stroke parameters, the current line miter limit is examined by `Context#stroke`, `Context#stroke_extents`,
    # and `Context#stroke_to_path`, but does not have any effect during path construction.
    #
    # The default miter limit value is 10.0, which will convert joins with interior angles less than 11 degrees to bevels instead of miters.
    # For reference, a miter limit of 2.0 makes the miter cutoff at 60 degrees, and a miter limit of 1.414 makes the cutoff at 90 degrees.
    #
    # A miter limit for a desired angle can be computed as: miter limit = 1/sin(angle/2)
    #
    # ###Parameters
    # - **limit** miter limit to set
    def miter_limit=(limit : Float64)
      LibCairo.set_miter_limit(@cairo, limit)
      self
    end

    def translate(tx : Float64, ty : Float64)
      LibCairo.translate(@cairo, tx, ty)
      self
    end

    def scale(sx : Float64, sy : Float64)
      LibCairo.scale(@cairo, sx, sy)
      self
    end

    def rotate(angle : Float64)
      LibCairo.rotate(@cairo, angle)
      self
    end

    def transform(matrix : Matrix)
      LibCairo.transform(@cairo, matrix.to_unsafe)
    end

    def matrix=(matrix : Matrix)
      LibCairo.set_matrix(@cairo, matrix.to_unsafe)
      self
    end

    def identity_matrix
      LibCairo.identity_matrix(@cairo)
      self
    end

    def user_to_device : Point
      LibCairo.user_to_device(@cairo, out x, out y)
      Point.new(x, y)
    end

    def user_to_device_distance : Point
      LibCairo.user_to_device_distance(@cairo, out x, out y)
      Point.new(x, y)
    end

    def device_to_user : Point
      LibCairo.device_to_user(@cairo, out x, out y)
      Point.new(x, y)
    end

    def device_to_user_distance : Point
      LibCairo.device_to_user_distance(@cairo, out x, out y)
      Point.new(x, y)
    end

    def new_path
      LibCairo.new_path(@cairo)
      self
    end

    def move_to(x : Float64, y : Float64)
      LibCairo.move_to(@cairo, x, y)
      self
    end

    def move_to(p : Point)
      LibCairo.move_to(@cairo, p.x, p.y)
      self
    end

    def new_sub_path
      LibCairo.new_sub_path(@cairo)
      self
    end

    def line(x1 : Float64, y1 : Float64, x2 : Float64, y2 : Float64)
      LibCairo.move_to(@cairo, x1, y1)
      LibCairo.line_to(@cairo, x2, y2)
      self
    end

    def line(p1 : Point, p2 : Point)
      LibCairo.move_to(@cairo, p1.x, p1.y)
      LibCairo.line_to(@cairo, p2.x, p2.y)
      self
    end

    def line_to(x : Float64, y : Float64)
      LibCairo.line_to(@cairo, x, y)
      self
    end

    def line_to(p : Point)
      LibCairo.line_to(@cairo, p.x, p.y)
      self
    end

    def curve_to(x1 : Float64, y1 : Float64,
                 x2 : Float64, y2 : Float64,
                 x3 : Float64, y3 : Float64)
      LibCairo.curve_to(@cairo, x1, y1, x2, y2, x3, y3)
      self
    end

    def curve_to(p1 : Point, p2 : Point, p3 : Point)
      LibCairo.curve_to(@cairo, p1.x, p1.y, p2.x, p2.y, p3.x, p3.y)
      self
    end

    def arc(xc : Int32 | Float64, yc : Int32 | Float64, radius : Int32 | Float64,
            angle1 : Float64, angle2 : Float64)
      LibCairo.arc(@cairo, xc, yc, radius, angle1, angle2)
      self
    end

    def arc(c : Point, radius : Float64, angle1 : Float64, angle2 : Float64)
      LibCairo.arc(@cairo, c.x, c.y, radius, angle1, angle2)
      self
    end

    def arc_negative(xc : Float64, yc : Float64,
                     radius : Float64, angle1 : Float64, angle2 : Float64)
      LibCairo.arc_negative(@cairo, xc, yc, radius, angle1, angle2)
      self
    end

    def arc_negative(c : Point, radius : Float64, angle1 : Float64, angle2 : Float64)
      LibCairo.arc_negative(@cairo, c.x, c.y, radius, angle1, angle2)
      self
    end

    def rel_move_to(dx : Float64, dy : Float64)
      LibCairo.rel_move_to(@cairo, dx, dy)
      self
    end

    def rel_move_to(d : Point)
      LibCairo.rel_move_to(@cairo, d.x, d.y)
      self
    end

    def rel_line_to(dx : Float64, dy : Float64)
      LibCairo.rel_line_to(@cairo, dx, dy)
      self
    end

    def rel_line_to(d : Point)
      LibCairo.rel_line_to(@cairo, d.x, d.y)
      self
    end

    def rel_curve_to(dx1 : Float64, dy1 : Float64,
                     dx2 : Float64, dy2 : Float64,
                     dx3 : Float64, dy3 : Float64)
      LibCairo.rel_curve_to(@cairo, dx1, dy1, dx2, dy2, dx3, dy3)
      self
    end

    def rel_curve_to(d1 : Point, d2 : Point, d3 : Point)
      LibCairo.rel_curve_to(@cairo, d1.x, d1.y, d2.x, d2.y, d3.x, d3.y)
      self
    end

    def rectangle(x : Float64, y : Float64, width : Float64, height : Float64)
      LibCairo.rectangle(@cairo, x, y, width, height)
      self
    end

    def close_path
      LibCairo.close_path(@cairo)
      self
    end

    def path_extents : Extents
      LibCairo.path_extents(@cairo, out x1, out y1, out x2, out y2)
      Extents.new(x1, y1, x2, y2)
    end

    # A drawing operator that paints the current source everywhere within the current clip region.
    def paint
      LibCairo.paint(@cairo)
      self
    end

    # A drawing operator that paints the current source everywhere within the current clip region
    # using a mask of constant alpha value alpha. The effect is similar to `Context#paint`,
    # but the drawing is faded out using the alpha value.
    #
    # ###Parameters
    # - **alpha** alpha value, between 0 (transparent) and 1 (opaque)
    def paint_with_alpha(alpha : Float64)
      LibCairo.paint_with_alpha(@cairo, alpha)
      self
    end

    # A drawing operator that paints the current source using the alpha channel of pattern as a mask.
    # (Opaque areas of pattern are painted with the source, transparent areas are not painted.)
    #
    # ###Parameters
    # - **pattern** a `Pattern`
    def mask(pattern : Pattern)
      LibCairo.mask(@cairo, pattern.to_unsafe)
      self
    end

    # A drawing operator that paints the current source using the alpha channel of surface as a mask.
    # (Opaque areas of surface are painted with the source, transparent areas are not painted.)
    #
    # ###Parameters
    # **surface** a `Surface`
    # **surface_x** X coordinate at which to place the origin of surface
    # **surface_y** Y coordinate at which to place the origin of surface
    def mask_surface(surface : Surface, surface_x : Float64, surface_y : Float64)
      LibCairo.mask_surface(surface.to_unsafe, surface_x, surface_y)
      self
    end

    # A drawing operator that strokes the current path according to the current line width, line join,
    # line cap, and dash settings. After `Context#stroke`, the current path will be cleared from the cairo context.
    # See `Context#line_width=`, `Context#line_join=`, `Context#line_cap=`, `Context#set_dash`, and `Context#stroke_preserve`.
    #
    # Note: Degenerate segments and sub-paths are treated specially and provide a useful result. These can result in two different situations:
    # 1. Zero-length "on" segments set in `Context#set_dash`. If the cap style is `LineCap::Round` or `LineCap::Square`
    # then these segments will be drawn as circular dots or squares respectively. In the case of `LineCap::Square`,
    # the orientation of the squares is determined by the direction of the underlying path.
    # 2. A sub-path created by `Context#move_to` followed by either a `Cntext#close_path`
    # or one or more calls to `Context#line_to` to the same coordinate as the `Context#move_to`.
    # If the cap style is `LineCap::Round` then these sub-paths will be drawn as circular dots.
    # Note that in the case of `LineCap::Square` a degenerate sub-path will not be drawn at all,
    # (since the correct orientation is indeterminate).
    #
    # In no case will a cap style of `LineCap::Butt` cause anything to be drawn in the case of either degenerate segments or sub-paths.
    def stroke
      LibCairo.stroke(@cairo)
      self
    end

    # A drawing operator that strokes the current path according to the current line width,
    # line join, line cap, and dash settings. Unlike `Context#stroke`, `Context#stroke_preserve` preserves the path within the cairo context.
    #
    # See `Context#line_width=`, `Context#line_join=`, `Context#line_cap=`, `Context#set_dash`, and `Context#stroke_preserve`.
    def stroke_preserve
      LibCairo.stroke_preserve(@cairo)
      self
    end

    # A drawing operator that fills the current path according to the current fill rule,
    # (each sub-path is implicitly closed before being filled). After `Context#fill`,
    # the current path will be cleared from the cairo context.
    # See `Context#fill_rule=` and `Context#fill_preserve`.
    def fill
      LibCairo.fill(@cairo)
      self
    end

    # A drawing operator that fills the current path according to the current fill rule,
    # (each sub-path is implicitly closed before being filled). Unlike `Context#fill`,
    # `Context#fill_preserve` preserves the path within the cairo context.
    #
    # See `Context#fill_rule=` and `Context#fill`.
    def fill_preserve
      LibCairo.fill_preserve(@cairo)
      self
    end

    # Emits the current page for backends that support multiple pages, but doesn't clear it, so,
    # the contents of the current page will be retained for the next page too.
    # Use `Context#show_page` if you want to get an empty page after the emission.
    #
    # This is a convenience function that simply calls `Surface#copy_page` on context's target.
    def copy_page
      LibCairo.copy_page(@cairo)
      self
    end

    # Emits and clears the current page for backends that support multiple pages.
    # Use `Context#copy_page` if you don't want to clear the page.
    #
    # This is a convenience function that simply calls `Surface#show_page` on context's target.
    def show_page
      LibCairo.show_page(@cairo)
      self
    end

    # Tests whether the given point is inside the area that would be affected by a `Context#stroke` operation
    # given the current path and stroking parameters. Surface dimensions and clipping are not taken into account.
    #
    # See `Context#stroke`, `Context#line_width=`, `Context#line_join=`, `Context#line_cap=`, `Context#set_dash`, and `Context#stroke_preserve`.
    # ###Parameters
    # - **x** X coordinate of the point to test
    # - **y** Y coordinate of the point to test
    #
    # ###Returns
    # A non-zero value if the point is inside, or zero if outside.
    def in_stroke(x : Float64, y : Float64) : Bool
      LibCairo.in_stroke(@cairo, x, y) == 1
    end

    def in_stroke(p : Point) : Bool
      LibCairo.in_stroke(@cairo, p.x, p.y) == 1
    end

    # Tests whether the given point is inside the area that would be affected by a `Context#fill` operation
    # given the current path and filling parameters. Surface dimensions and clipping are not taken into account.
    #
    # See `Context#fill`, `Context#fill_rule=` and `Context#fill_preserve`.
    #
    # ###Parameters
    # - **x** X coordinate of the point to test
    # - **y** Y coordinate of the point to test
    #
    # ###Returns
    # A non-zero value if the point is inside, or zero if outside.
    def in_fill(x : Float64, y : Float64) : Bool
      LibCairo.in_fill(@cairo, x, y) == 1
    end

    # Tests whether the given point is inside the area that would be affected by a `Context#fill` operation
    # given the current path and filling parameters. Surface dimensions and clipping are not taken into account.
    #
    # See `Context#fill`, `Context#fill_rule=` and `Context#fill_preserve`.
    #
    # ###Parameters
    # - **p** the point to test
    #
    # ###Returns
    # A non-zero value if the point is inside, or zero if outside.
    def in_fill(p : Point) : Bool
      LibCairo.in_fill(@cairo, p.x, p.y) == 1
    end

    def in_clip(x : Float64, y : Float64) : Bool
      LibCairo.in_clip(@cairo, x, y) == 1
    end

    # Tests whether the given point is inside the area that would be visible through the current clip,
    # i.e. the area that would be filled by a `Context#paint` operation.
    #
    # See `Context#clip`, and `Context#clip_preserve`.
    #
    # ###Parameters
    # - **p** the point to test
    #
    # ###Returns
    # **true** if the point is inside, or **false** if outside.
    def in_clip(p : Point) : Bool
      LibCairo.in_clip(@cairo, p.x, p.y) == 1
    end

    # Computes a bounding box in user coordinates covering the area that would be affected, (the "inked" area),
    # by a `Context#stroke` operation given the current path and stroke parameters. If the current path is empty,
    # returns an empty rectangle ((0,0), (0,0)). Surface dimensions and clipping are not taken into account.
    #
    # Note that if the line width is set to exactly zero, then `Context#stroke_extents` will return an empty rectangle.
    # Contrast with `Context#path_extents` which can be used to compute the non-empty bounds as the line width approaches zero.
    #
    # Note that `Context#stroke_extents` must necessarily do more work to compute the precise inked areas in light of the stroke parameters,
    # so `Context#path_extents` may be more desirable for sake of performance if non-inked path extents are desired.
    #
    # See `Context#stroke`, `Context#line_width=`, `Context#`line_join=`, `Context#line_cap=`, `Context#set_dash`, and `Context#stroke_preserve`.
    #
    # ###Parameters
    # - **x1** left of the resulting extents
    # - **y1** top of the resulting extents
    # - **x2** right of the resulting extents
    # - **y2** bottom of the resulting extents
    def stroke_extents : Extents
      LibCairo.stroke_extents(@cairo, out x1, out y1, out x2, out y2)
      Extents.new(x1, y1, x2, y2)
    end

    # Computes a bounding box in user coordinates covering the area that would be affected,
    # (the "inked" area), by a `Context#fill` operation given the current path and fill parameters.
    # If the current path is empty, returns an empty rectangle ((0,0), (0,0)).
    # Surface dimensions and clipping are not taken into account.
    #
    # Contrast with `Context#path_extents`, which is similar, but returns non-zero extents for some paths with no inked area,
    # (such as a simple line segment).
    #
    # Note that `Context#fill_extents` must necessarily do more work to compute the precise inked areas in light of the fill rule,
    # so `Context#path_extents` may be more desirable for sake of performance if the non-inked path extents are desired.
    #
    # See `Context#fill`, `Context#fill_rule=` and `Context#fill_preserve`.
    #
    # ###Parameters
    # - **x1** left of the resulting extents
    # - **y1** top of the resulting extents
    # - **x2** right of the resulting extents
    # - **y2** bottom of the resulting extents
    def fill_extents(x1 : Float64, y1 : Float64, x2 : Float64, y2 : Float64)
      LibCairo.fill_extents(@cairo, x1, y1, x2, y2)
      self
    end

    # Computes a bounding box in user coordinates covering the area that would be affected,
    # (the "inked" area), by a `Context#fill` operation given the current path and fill parameters.
    # If the current path is empty, returns an empty rectangle ((0,0), (0,0)).
    # Surface dimensions and clipping are not taken into account.
    #
    # Contrast with `Context#path_extents`, which is similar, but returns non-zero extents for some paths with no inked area,
    # (such as a simple line segment).
    #
    # Note that `Context#fill_extents` must necessarily do more work to compute the precise inked areas in light of the fill rule,
    # so `Context#path_extents` may be more desirable for sake of performance if the non-inked path extents are desired.
    #
    # See `Context#fill`, `Context#fill_rule=` and `Context#fill_preserve`.
    #
    # ###Parameters
    # - **p1** top-left corner of the resulting extents
    # - **p2** bottom-right corner of the resulting extents
    def fill_extents(p1 : Point, p2 : Point)
      LibCairo.fill_extents(@cairo, p1.x, p1.y, p2.x, p2.y)
      self
    end

    # Computes a bounding box in user coordinates covering the area that would be affected,
    # (the "inked" area), by a `Context#fill` operation given the current path and fill parameters.
    # If the current path is empty, returns an empty rectangle ((0,0), (0,0)).
    # Surface dimensions and clipping are not taken into account.
    #
    # Contrast with `Context#path_extents`, which is similar, but returns non-zero extents for some paths with no inked area,
    # (such as a simple line segment).
    #
    # Note that `Context#fill_extents` must necessarily do more work to compute the precise inked areas in light of the fill rule,
    # so `Context#path_extents` may be more desirable for sake of performance if the non-inked path extents are desired.
    #
    # See `Context#fill`, `Context#fill_rule=` and `Context#fill_preserve`.
    #
    # ###Parameters
    # - **extents** the resulting extents
    def fill_extents(extents : Extents)
      LibCairo.fill_extents(@cairo, extents.x1, extents.y1, extents.x2, extents.y2)
      self
    end

    # Reset the current clip region to its original, unrestricted state.
    # That is, set the clip region to an infinitely large shape containing the target surface.
    # Equivalently, if infinity is too hard to grasp, one can imagine the clip region being reset to the exact bounds of the target surface.
    #
    # Note that code meant to be reusable should not call `Context#reset_clip` as it will cause results unexpected by higher-level code
    # which calls `Context#clip`. Consider using `Context#save` and `Context#restore` around `Context#clip` as a more robust means
    # of temporarily restricting the clip region.
    def reset_clip
      LibCairo.reset_clip(@cairo)
      self
    end

    # Establishes a new clip region by intersecting the current clip region with the current path as it
    # would be filled by `Context#fill` and according to the current fill rule (see `Context#fill_rule=`).
    #
    # After `Context#clip`, the current path will be cleared from the cairo context.
    #
    # The current clip region affects all drawing operations by effectively masking out any changes to
    # the surface that are outside the current clip region.
    #
    # Calling `Context#clip` can only make the clip region smaller, never larger.
    # But the current clip is part of the graphics state, so a temporary restriction of the clip region
    # can be achieved by calling `Context#clip` within a `Context#save`/`Context#restore` pair.
    # The only other means of increasing the size of the clip region is `Context#reset_clip`.
    def clip
      LibCairo.clip(@cairo)
      self
    end

    # Establishes a new clip region by intersecting the current clip region with the current path as
    # it would be filled by `Context#fill` and according to the current fill rule (see `Context#fill_rule=`).
    #
    # Unlike `Context#clip`, `Context#clip_preserve` preserves the path within the cairo context.
    #
    # The current clip region affects all drawing operations by effectively masking out any changes
    # to the surface that are outside the current clip region.
    #
    # Calling `Context#clip_preserve` can only make the clip region smaller, never larger.
    # But the current clip is part of the graphics state, so a temporary restriction of the clip region
    # can be achieved by calling `Context#clip_preserve` within a `Context#save`/`Context#restore` pair.
    # The only other means of increasing the size of the clip region is `Context#reset_clip`.
    def clip_preserve
      LibCairo.clip_preserve(@cairo)
      self
    end

    # Computes a bounding box in user coordinates covering the area inside the current clip.
    #
    # ###Parameters
    # - **x1** left of the resulting extents
    # - **y1** top of the resulting extents
    # - **x2** right of the resulting extents
    # - **y2** bottom of the resulting extents
    def clip_extents : Extents
      LibCairo.clip_extents(@cairo, out x1, out y1, out x2, out y2)
      Extents.new(x1, y1, x2, y2)
    end

    # Gets the current clip region as a list of rectangles in user coordinates. Never returns `Nil`.
    # The status in the list may be `Status::ClipNotRepresentable` to indicate that the clip region
    # cannot be represented as a list of user-space rectangles. The status may have other values to indicate other errors.
    #
    # ###Returns
    # The current clip region as a list of rectangles in user coordinates, which should be destroyed using `RectangleList#finalize`.
    def copy_clip_rectangle_list : RectangleList?
      list = LibCairo.copy_clip_rectangle_list(@cairo)
      if list.null?
        nil
      else
        RectangleList.new(list)
      end
    end

    def select_font_face(family : String, slant : FontSlant, weight : FontWeight)
      LibCairo.select_font_face(@cairo, family.to_unsafe,
                                LibCairo::FontSlantT.new(slant.value),
                                LibCairo::FontWeightT.new(weight.value))
      self
    end

    def font_size=(size : Float64)
      LibCairo.set_font_size(@cairo, size)
      self
    end

    def font_matrix : Matrix
      matrix = Matrix.new
      LibCairo.get_font_matrix(@cairo, matrix.to_unsafe)
      matrix
    end

    def font_matrix=(matrix : Matrix)
      LibCairo.set_font_matrix(@cairo, matrix.to_unsafe)
      self
    end

    def font_options : FontOptions
      font_options = FontOptions.new
      LibCairo.get_font_options(@cairo, font_options.to_unsafe)
      font_options
    end

    def font_options=(options : FontOptions)
      LibCairo.set_font_options(@cairo, options.to_unsafe)
      self
    end

    def font_face : FontFace
      font_face = LibCairo.get_font_face(@cairo)
      FontFace.new(font_face)
    end

    def font_face=(font_face : FontFace)
      LibCairo.set_font_face(@cairo, font_face.to_unsafe)
      self
    end

    def scaled_font : ScaledFont
      scaled_font = LibCairo.get_scaled_font(@cairo)
      ScaledFont.new(scaled_font)
    end

    def scaled_font=(scaled_font : ScaledFont)
      LibCairo.set_scaled_font(@cairo, scaled_font.value)
      self
    end

    def show_text(text : String)
      LibCairo.show_text(@cairo, text.to_unsafe)
      self
    end

    def show_glyphs(glyphs : Array(Glyph))
      raise "unimplemented method"
    end

    def show_text_glyphs(text : String, glyphs : Array(Glyph),
                         clusters : Array(TextCluster),
                         cluster_flags : TextClusterFlags)
      raise "unimplemented method"
    end

    def text_path(text : String)
      LibCairo.text_path(@cairo, text.to_unsafe)
      self
    end

    def glyph_path(glyphs : Array(Glyph))
      raise "unimplemented method"
    end

    def text_extents(text : String) : TextExtents
      LibCairo.text_extents(@cairo, text.to_unsafe, out text_extents)
      TextExtents.new(text_extents)
    end

    def glyph_extents(glyphs : Array(Glyph)) : TextExtents
      raise "unimplemented method"
    end

    def font_extents : FontExtents
      LibCairo.font_extents(@cairo, out font_extents)
      FontExtents.new(font_extents)
    end

    # Gets the current compositing operator for a cairo context.
    #
    # ###Returns
    # The current compositing operator.
    def operator : Operator
      Operator.new(LibCairo.get_operator(@cairo).value)
    end

    # Gets the current source pattern
    #
    # ###Returns
    # The current source pattern. This object is owned by cairo. To keep a reference to it, you must call `Pattern#reference`.
    def source : Pattern
      Pattern.new(LibCairo.get_source(@cairo))
    end

    # Gets the current tolerance value, as set by `Context#tolerance=`.
    #
    # ###Returns
    # The current tolerance value.
    def tolerance : Float64
      LibCairo.get_tolerance(@cairo)
    end

    # Gets the current shape antialiasing mode, as set by `Context#antialias=`.
    #
    # ###Returns
    # The current shape antialiasing mode.
    def antialias : Antialias
      Antialias.new(LibCairo.get_antialias(@cairo).value)
    end

    def has_current_point? : Bool
      LibCairo.has_current_point(@cairo) == 1
    end

    def current_point : Point
      LibCairo.get_current_point(@cairo, out x, out y)
      Point.new(x, y)
    end

    # Gets the current fill rule, as set by `Contex#fill_rule=`.
    #
    # ###Returns
    # The current fill rule.
    def fill_rule : FillRule
      FillRule.new(LibCairo.get_fill_rule(@cairo).value)
    end

    # This function returns the current line width value exactly as set by `Context#line_width=`.
    # Note that the value is unchanged even if the CTM has changed between the calls to `Context#line_width=` and `Context#line_width`.
    #
    # ###Returns
    # The current line width.
    def line_width : Float64
      LibCairo.get_line_width(@cairo)
    end

    # Gets the current line cap style, as set by `Context#line_cap=`.
    #
    # ###Returns
    # The current line cap style.
    def line_cap : LineCap
      LineCap.new(LibCairo.get_line_cap(@cairo).value)
    end

    # Gets the current line join style, as set by `Context#line_join=`.
    #
    # ###Returns
    # The current line join style.
    def line_join : LineJoin
      LineJoin.new(LibCairo.get_line_join(@cairo).value)
    end

    # Gets the current miter limit, as set by `Context#miter_limit=`.
    #
    # ###Returns
    # The current miter limit.
    def miter_limit : Float64
      LibCairo.get_miter_limit(@cairo)
    end

    # This function returns the length of the dash array in `Context` (0 if dashing is not currently in effect).
    #
    # See also `Context#set_dash` and `Context#dash`.
    #
    # ###Returns
    # The length of the dash array, or 0 if no dash array set.
    def dash_count : Int32
      LibCairo.get_dash_count(@cairo)
    end

    # Gets the current dash array. If not empty, dashes should be big enough to hold at least the number of values returned
    # by `Context#dash_count`.
    def dash : NamedTuple(dashes: Float64, offset: Float64)
      LibCairo.get_dash(@cairo, out dashes, out offset)
      {dashes: dashes, offset: offset}
    end

    def matrix : Matrix
      LibCairo.get_matrix(@cairo, out matrix)
      Matrix.new(matrix)
    end

    # Gets the target surface for the cairo context as passed to `Context#initialized`.
    #
    # This function will always return a valid object, but the result can be a "nil" surface if `Context` is already in an error state,
    # (ie. `Context#state` != `State::Success`).
    #
    # ###Returns
    # The target surface. This object is owned by cairo. To keep a reference to it, you must call `Surface#reference`.
    def target : Surface
      Surface.new(LibCairo.get_target(@cairo))
    end

    # Gets the current destination surface for the context. This is either the original target surface as passed to `Context#initialize`
    # or the target surface for the current group as started by the most recent call to `Context#push_group` or `Context#push_group_with_content`.
    #
    # This function will always return a valid pointer, but the result can be a "nil" surface if `Context` is already in an error state,
    # (ie. `Context#status` != `Status::Success`). A Nil surface is indicated by `Surface#status` != `Status::Success`.
    #
    # ###Returns
    # The target surface. This object is owned by cairo. To keep a reference to it, you must call `Surface#reference`.
    def group_target : Surface
      Surface.new(LibCairo.get_group_target(@cairo))
    end

    def copy_path : Path
      Path.new(LibCairo.copy_path(@cairo))
    end

    def copy_path_flat : Path
      Path.new(LibCairo.copy_path_flat(@cairo))
    end

    def append(path : Path)
      LibCairo.append_path(@cairo, path.to_unsafe)
      self
    end

    # Checks whether an error has previously occurred for this context.
    #
    # ###Returns
    # The current status of this context, see `Status`.
    def status : Status
      Status.new(LibCairo.status(@cairo).value)
    end

    def to_unsafe : LibCairo::PCairoT
      @cairo
    end
  end
end
