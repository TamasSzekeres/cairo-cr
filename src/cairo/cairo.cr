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

    alias PPatternT = Void*

    alias DestroyFuncT = Void* -> Void

    alias PUserDataKeyT = UserDataKeyT*
    struct UserDataKeyT
      unused : Int32
    end

    enum StatusT
      SUCCESS = 0,

      NO_MEMORY,
      INVALID_RESTORE,
      INVALID_POP_GROUP,
      NO_CURRENT_POINT,
      INVALID_MATRIX,
      INVALID_STATUS,
      NULL_POINTER,
      INVALID_STRING,
      INVALID_PATH_DATA,
      READ_ERROR,
      WRITE_ERROR,
      SURFACE_FINISHED,
      SURFACE_TYPE_MISMATCH,
      PATTERN_TYPE_MISMATCH,
      INVALID_CONTENT,
      INVALID_FORMAT,
      INVALID_VISUAL,
      FILE_NOT_FOUND,
      INVALID_DASH,
      INVALID_DSC_COMMENT,
      INVALID_INDEX,
      CLIP_NOT_REPRESENTABLE,
      TEMP_FILE_ERROR,
      INVALID_STRIDE,
      FONT_TYPE_MISMATCH,
      USER_FONT_IMMUTABLE,
      USER_FONT_ERROR,
      NEGATIVE_COUNT,
      INVALID_CLUSTERS,
      INVALID_SLANT,
      INVALID_WEIGHT,
      INVALID_SIZE,
      USER_FONT_NOT_IMPLEMENTED,
      DEVICE_TYPE_MISMATCH,
      DEVICE_ERROR,
      INVALID_MESH_CONSTRUCTION,
      DEVICE_FINISHED,
      JBIG2_GLOBAL_MISSING,

      LAST_STATUS
    end

    enum ContentT
      COLOR       = 0x1000,
      ALPHA       = 0x2000,
      COLOR_ALPHA = 0x3000
    end

    enum FormatT
      INVALID   = -1,
      ARGB32    = 0,
      RGB24     = 1,
      A8        = 2,
      A1        = 3,
      RGB16_565 = 4,
      RGB30     = 5
    end

    # closure, data, length -> status
    alias WriteFuncT = Void*, UInt8*, UInt32 -> StatusT

    # closire, data, length -> status
    alias ReadFuncT = Void*, UInt8*, Int32 -> StatusT

    struct RectangleIntT {
      x, y : Int32
      width, height : Int32
    end

    # Functions for manipulating state objects
    fun create = cairo_create(target : PSurfaceT) : PCairoT

    fun reference = cairo_reference(cr : PCairoT) : PCairoT

    fun destroy = cairo_destroy(cr : PCairoT) : Void

    fun get_reference_count = cairo_get_reference_count(cr:  PCairoT) : UInt32

    fun get_user_date = cairo_get_user_data(
      cr : PCairoT,
      key : PUserDataKeyT
    ) : Void*

    fun set_user_date = cairo_set_user_data(
      cr : PCairoT,
      key : PUserDataKeyT,
      user_data : Void*,
      destroy : DestroyFuncT
    ) : StatusT

    fun save = cairo_save(cr : PCairoT) : Void

    fun restore = cairo_restore(cr : PCairoT) : Void

    fun push_group = cairo_push_group(cr : PCairoT) : Void

    fun push_group_with_content = cairo_push_group_with_content(
      cr : PCairoT,
      content : ContentT
    ) : Void

    fun pop_group = cairo_pop_group(cr : PCairoT) : PPatternT

    fun pop_group_to_source = cairo_pop_group_to_source(cr : PCairoT) : PCairoT

    # Modify state

    enum OperatorT
      CLEAR,

      SOURCE,
      OVER,
      IN,
      OUT,
      ATOP,

      DEST,
      DEST_OVER,
      DEST_IN,
      DEST_OUT,
      DEST_ATOP,

      XOR,
      ADD,
      SATURATE,

      MULTIPLY,
      SCREEN,
      OVERLAY,
      DARKEN,
      LIGHTEN,
      COLOR_DODGE,
      COLOR_BURN,
      HARD_LIGHT,
      SOFT_LIGHT,
      DIFFERENCE,
      EXCLUSION,
      HSL_HUE,
      HSL_SATURATION,
      HSL_COLOR,
      HSL_LUMINOSITY
    end

    fun set_operator = cairo_set_operator(
      cr : PCairoT,
      op : OperatorT
    ) : Void

    fun set_source = cairo_set_source(
      cr : PCairoT,
      source : PPatternT
    ) : Void

    fun set_source_rgb = cairo_set_source_rgb(
      cr : PCairoT,
      red : Float64,
      green : Float64,
      blue : Float64
    ) : Void

    fun set_source_rgba = cairo_set_source_rgba(
      cr : PCairoT,
      red : Float64,
      green : Float64,
      blue : Float64,
      alpha : Float64
    ) : Void

    fun set_source_surface = cairo_set_source_surface(
      cr : PCairoT,
      surface : PSurfaceT,
      x : Float64,
      y : Float64
    ) : Void

    fun set_tolerance = cairo_set_tolerance(
      cr : PCairoT,
      tolerance : Float64
    ) : Void

    enum AntialiasT
      ANTIALIAS_DEFAULT,

      # method
      ANTIALIAS_NONE,
      ANTIALIAS_GRAY,
      ANTIALIAS_SUBPIXEL,

      # hints
      ANTIALIAS_FAST,
      ANTIALIAS_GOOD,
      ANTIALIAS_BEST
    end

    fun set_antialias = cairo_set_antialias(
      cr : PCairoT,
      antialias : AntialiasT
    ) : Void

    enum FillRuleT {
      WINDING,
      EVEN_ODD
    end

    fun set_fill_rule = cairo_set_fill_rule(
      cr : PCairoT,
      fill_rule : FillRuleT
    ) : Void

    fun set_line_width = cairo_set_line_width(
      cr : PCairoT,
      width : Float64
    ) : Void

    enum LineCapT
      BUTT,
      ROUND,
      SQUARE
    end

    fun set_line_cap = cairo_set_line_cap(
      cr : PCairoT,
      line_cap : LineCapT
    ) : Void

    enum LineJoinT
      MITER,
      ROUND,
      BEVEL
    end

    fun set_line_join = cairo_set_line_join(
      cr : PCairoT,
      line_join : LineJoinT
    ) : Void

    fun set_dash = cairo_set_dash(
      cr : PCairoT,
      dashes : Float64*,
      num_dashes : Int32,
      offset : Float64
    ) : Void

    fun set_miter_limit = cairo_set_miter_limit(
      cr : PCairoT,
      limit : Float64
    ) : Void

    fun translate = cairo_translate(
      cr : PCairoT,
      tx : Float64,
      ty : Float64
    ) : Void

    fun scale = cairo_scale(
      cr : PCairoT,
      sx : Float64,
      sy : Float64
    ) : Void

    fun rotate = cairo_rotate(
      cr : PCairoT,
      angle : Float64
    ) : Void

    fun transform = cairo_transform(
      cr : PCairoT,
      matrix : PMatrixT
    ) : Void

    fun set_matrix = cairo_set_matrix(
      cr : PCairoT,
      matrix : PMatrixT
    ) : Void

    fun identity_matrix = cairo_identity_matrix(
      cr : PCairoT
    ) : Void

    fun user_to_device = cairo_user_to_device(
      cr : PCairoT,
      x : Float64*,
      y : Float64*
    ) : Void

    fun user_to_device_distance = cairo_user_to_device_distance(
      cr : PCairoT,
      dx : Float64*,
      dy : Float64*
    ) : Void

    fun device_to_user = cairo_device_to_user(
      cr : PCairoT,
      x : Float64*,
      y : Float64*
    ) : Void

    fun device_to_user_distance = cairo_device_to_user_distance(
      cr : PCairoT,
      dx : Float64*,
      dy : Float64*
    ) : Void

    # Path creation functions
    fun new_path = cairo_new_path(
      cr : PCairoT
    ) : Void

    fun move_to = cairo_move_to(
      cr : PCairoT,
      x : Float64,
      y : Float64
    ) : Void

    fun new_sub_path = cairo_new_sub_path(
      cr : PCairoT
    ) : Void

    fun line_to = cairo_line_to(
      cr : PCairoT,
      x : Float64,
      y : Float64
    ) : Void

    fun curve_to = cairo_curve_to(
      cr : PCairoT,
      x1 : Float64,
      y1 : Float64,
      x2 : Float64,
      y2 : Float64,
      x3 : Float64,
      y3 : Float64
    ) : Void

    fun arc = cairo_arc(
      cr : PCairoT,
      xc : Float64,
      yc : Float64,
      radius : Float64,
      angle1 : Float64,
      angle2 : Float64
    ) : Void

    fun arc_negative = cairo_arc_negative(
      cr : PCairoT,
      xc : Float64,
      yc : Float64,
      radius : Float64,
      angle1 : Float64,
      angle2 : Float64
    ) : Void

    # XXX: NYI
    #fun arc_to = cairo_arc_to(
    #  cr : PCairoT,
    #  x1 : Float64,
    #  y1 : Float64,
    #  x2 : Float64,
    #  y2 : Float64,
    #  radius : Float64
    #) : Void

    fun rel_move_to = cairo_rel_move_to(
      cr : PCairoT,
      dx : Float64,
      dy : Float64
    ) : Void

    fun rel_line_to = cairo_rel_line_to(
      cr : PCairoT,
      dx : Float64,
      dy : Float64
    ) : Void

    fun rel_curve_to = cairo_rel_curve_to(
      cr : PCairoT,
      dx1 : Float64,
      dy1 : Float64,
      dx2 : Float64,
      dy2 : Float64,
      dx3 : Float64,
      dy3 : Float64
    ) : Void

    fun rectangle = cairo_rectangle(
      cr : PCairoT,
      x : Float64,
      y : Float64,
      width : Float64,
      height : Float64
    ) : Void

    # XXX: NYI
    #fun stroke_to_path = cairo_stroke_to_path(
    #  cr : PCairoT
    #) : Void

    fun close_path = cairo_close_path(
      cr : PCairoT
    ) : Void

    fun path_extents = cairo_path_extents(
      cr : PCairoT,
      x1 : Float64*,
      y1 : Float64*,
      x2 : Float64*,
      y2 : Float64*
    ) : Void

    # Painting functions
    fun paint = cairo_paint(
      cr : PCairoT
    ) : Void

    fun paint_with_alpha = cairo_paint_with_alpha(
      cr : PCairoT,
      alpha : Float64
    ) : Void

    fun mask = cairo_mask(
      cr : PCairoT,
      pattern : PPatternT
    ) : Void

    fun mask_surface = cairo_mask_surface(
      cr : PCairoT,
      surface : PSurfaceT,
      surface_x : Float64,
      surface_y : Float64
    ) : Void

    fun stroke = cairo_stroke(
      cr : PCairoT
    ) : Void

    fun stroke_preserve = cairo_stroke_preserve(
      cr : PCairoT
    ) : Void

    fun fill = cairo_fill(
      cr : PCairoT
    ) : Void

    fun fill_preserve = cairo_fill_preserve(
      cr : PCairoT
    ) : Void

    fun copy_page = cairo_copy_page(
      cr : PCairoT
    ) : Void

    fun show_page = cairo_show_page(
      cr : PCairoT
    ) : Void

    # Insideness testing
    fun in_stroke = cairo_in_stroke(
      cr : PCairoT,
      x : Float64,
      y : Float64
    ) : BoolT

    fun in_fill = cairo_in_fill(
      cr : PCairoT,
      x : Float64,
      y : Float64
    ) : BoolT

    fun in_clip = cairo_in_clip(
      cr : PCairoT,
      x : Float64,
      y : Float64
    ) : BoolT

    # Rectangular extents
    fun stroke_extets = cairo_stroke_extents(
      cr : PCairoT,
      x1 : Float64*,
      y1 : Float64*,
      x2 : Float64*,
      y2 : Float64*
    ) : Void

    fun fill_extents = cairo_fill_extents(
      cr : PCairoT,
      x1 : Float64,
      y1 : Float64,
      x2 : Float64,
      y2 : Float64
    ) : Void

    # Clipping
    fun reset_clip = cairo_reset_clip(
      cr : PCairoT
    ) : Void

    fun clip = cairo_clip(
      cr : PCairoT
    ) : Void

    fun clip_preserve = cairo_clip_preserve(
      cr : PCairoT
    ) : Void

    fun clip_extents = cairo_clip_extents(
      cr : PCairoT,
      x1 : Float64*,
      y1 : Float64*,
      x2 : Float64*,
      y2 : Float64*
    ) : Void

    alias PRectangleT = RectangleT*
    struct RectangleT
      x, y, width, height : Float64
    end

    alias PRectangleListT = RectangleListT*
    struct RectangleListT
      status : StatusT
      rectangles : PRectangleT
      num_rectangles : Int32
    end

    fun copy_clip_rectangle_list = cairo_copy_clip_rectangle_list(
      cr : PCairoT
    ) : PRectangleListT

    fun rectangle_list_destroy = cairo_rectangle_list_destroy(
      rectangle_list : PRectangleListT
    ) : Void

    # Font/Text functions

    alias PScaledFontT = Void*

    alias PFontFaceT = Void*

    alias PGlyphT = GlyphT*
    struct GlyphT
      index : UInt64
      x : Float64
      y : Float64
    end

    fun glyph_allocate = cairo_glyph_allocate(
      num_glyphs : Int32
    ) : PGlyphT

    fun glyph_free = cairo_glyph_free(
      glyphs : PGlyphT
    ) : Void

    alias PTextClusterT = TextClusterT*
    struct TextClusterT
      num_bytes : Int32
      num_glyphs : Int32
    end

    fun text_cluster_allocate = cairo_text_cluster_allocate(
      num_clusters : Int32
    ) : PTextClusterT

    fun text_cluster_free = cairo_text_cluster_free(
      clusters : PTextClusterT
    ) : Void

    enum TextClusterFlagsT
      BACKWARD = 0x00000001
    end

    alias PTextExtentsT = TextExtentsT*
    struct TextExtentsT
      x_bearing : Float64
      y_bearing : Float64
      width : Float64
      height : Float64
      x_advance : Float64
      y_advance : Float64
    end

    alias PFontExtentsT = FontExtentsT*
    struct FontExtentsT
      ascent : Float64
      descent : Float64
      height : Float64
      max_x_advance : Float64
      max_y_advance : Float64
    end

    enum FontSlantT
      NORMAL,
      ITALIC,
      OBLIQUE
    end

    enum FontWeightT
      NORMAL,
      BOLD
    end

    enum SubpixelOrderT
      DEFAULT,
      RGB,
      BGR,
      VRGB,
      VBGR
    end

    enum HintStyleT
      DEFAULT,
      NONE,
      SLIGHT,
      MEDIUM,
      FULL
    end

    enum HintMetricsT
      DEFAULT,
      OFF,
      ON
    end

    alias PFontOptionsT = Void*

    fun font_options_create = cairo_font_options_create(
    ) : PFontOptionsT

    fun font_optinos_copy = cairo_font_options_copy(
      original : PFontOptionsT
    ) : PFontOptionsT

    fun font_options_destroy = cairo_font_options_destroy(
      options : PFontOptionsT
    ) : Void

    fun font_options_status = cairo_font_options_status(
      options : PFontOptionsT
    ) : StatusT

    fun font_options_merge = cairo_font_options_merge(
      options : PFontOptionsT,
      other : PFontOptionsT
    ) : Void

    fun font_options_equal = cairo_font_options_equal(
      options : PFontOptionsT,
      other : PFontOptionsT
    ) : BoolT

    fun font_options_hash = cairo_font_options_hash(
      options : PFontOptionsT
    ) : UInt64

    fun font_options_set_antialias = cairo_font_options_set_antialias(
      options : PFontOptionsT,
      antialias : AntialiasT
    ) : Void

    fun font_options_get_antialias = cairo_font_options_get_antialias(
      options : PFontOptionsT
    ) : AntialiasT

    fun font_options_set_subpixel_order = cairo_font_options_set_subpixel_order(
      options : PFontOptionsT,
      subpixel_order : SubpixelOrderT
    ) : Void

    fun font_options_get_subpixel_order = cairo_font_options_get_subpixel_order(
      options : PFontOptionsT
    ) : SubpixelOrderT

    fun font_options_set_hint_style = cairo_font_options_set_hint_style(
      options : PFontOptionsT,
      hint_style : HintStyleT
    ) : Void

    fun font_options_get_hint_style = cairo_font_options_get_hint_style(
      options : PFontOptionsT
    ) : HintStyleT

    fun font_options_set_hint_metrics = cairo_font_options_set_hint_metrics(
      *options : PFontOptionsT,
      hint_metrics : HintMetricsT
    ) : Void

    fun font_options_get_hint_metrics = cairo_font_options_get_hint_metrics(
      options : PFontOptionsT
    ) : HintMetricsT

    # This interface is for dealing with text as text, not caring about the
    # font object inside the the CairoT.

    fun select_font_face = cairo_select_font_face(
      cr : PCairoT,
      family : UInt8*,
      slant : FontSlantT,
      weight : FontWeightT
    ) : Void

    fun set_font_size = cairo_set_font_size(
      cr : PCairoT,
      size : Float64
    ) : Void

    fun set_font_matrix = cairo_set_font_matrix(
      cr : PCairoT,
      matrix : PMatrixT
    ) : Void

    fun get_font_matrix = cairo_get_font_matrix(
      cr : PCairoT,
      matrix : PMatrixT
    ) : Void

    fun set_font_options = cairo_set_font_options(
      cr : PCairoT,
      options : PFontOptionsT
    ) : Void

    fun get_font_options = cairo_get_font_options(
      cr : PCairoT,
      options : PFontOptionsT
    ) : Void

    fun set_font_face = cairo_set_font_face(
      cr : PCairoT,
      font_face : PFontFaceT
    ) : Void

    fun get_font_face = cairo_get_font_face(
      cr : PCairoT
    ) : PFontFaceT

    fun set_scaled_font = cairo_set_scaled_font(
      cr : PCairoT,
      scaled_font : PScaledFontT
    ) : Void

    fun get_scaled_font = cairo_get_scaled_font(
      cr : PCairoT
    ) : PScaledFontT

    fun show_text = cairo_show_text(
      cr : PCairoT,
      utf8 : UInt8*
    ) : Void

    fun show_glyphs = cairo_show_glyphs(
      cr : PCairoT,
      glyphs : PGlyphT,
      num_glyphs : Int32
    ) : Void

    fun show_text_glyphs = cairo_show_text_glyphs(
      cr : PCairoT,
      utf8 : UInt8*,
      utf8_len : Int32,
      glyphs : PGlyphT,
      num_glyphs : Int32,
      clusters : PTextClusterT,
      num_clusters : Int32,
      cluster_flags : TextClusterFlagsT
    ) : Void

    fun text_path = cairo_text_path(
      cr : PCairoT,
      utf8 : UInt8*
    ) : Void

    fun glyph_path = cairo_glyph_path(
      cr : PCairoT,
      glyphs : PGlyphT,
      num_glyphs : Int32
    ) : Void

    fun text_extents = cairo_text_extents(
      cr : PCairoT,
      utf8 : UInt8*,
      extents : PTextExtentsT
    ) : Void

    fun glyph_extents = cairo_glyph_extents(
      cr : PCairoT,
      glyphs : PGlyphT,
      num_glyphs : Int32,
      extents : PTextExtentsT
    ) : Void

    fun font_extents = cairo_font_extents(
      cr : PCairoT,
      extents : PFontExtentsT
    ) : Void

    # Generic identifier for a font style

    fun font_face_reference = cairo_font_face_reference(
      font_face : PFontFaceT
    ) : PFontFaceT

    fun font_face_destroy = cairo_font_face_destroy(
      font_face : PFontFaceT
    ) : Void

    fun font_face_get_reference_count = cairo_font_face_get_reference_count(
      font_face : PFontFaceT
    ) : UInt32

    fun font_face_status = cairo_font_face_status(
      font_face : PFontFaceT
    ) : StatusT

    enum FontTypeT
      TOY,
      FT,
      WIN32,
      QUARTZ,
      USER
    end

    fun font_face_get_type = cairo_font_face_get_type(
      font_face : PFontFaceT
    ) : FontTypeT

    fun font_face_get_user_data = cairo_font_face_get_user_data(
      font_face : PFontFaceT,
      key : PUserDataKeyT
    ) : Void*

    fun font_face_set_user_data = cairo_font_face_set_user_data(
      font_face : PFontFaceT,
      key : PUserDataKeyT,
      user_data : Void*,
      destroy : DestroyFuncT
    ) : StatusT

    # Portable interface to general font features.

    fun scaled_font_create = cairo_scaled_font_create(
      font_face : PFontFaceT,
      font_matrix : PMatrixT,
      ctm : PMatrixT,
      options : PFontOptionsT
    ) : PScaledFontT

    fun scaled_font_reference = cairo_scaled_font_reference(
      scaled_font : PScaledFontT
    ) : PScaledFontT

    fun scaled_font_destroy = cairo_scaled_font_destroy(
      scaled_font : PScaledFontT
    ) : Void

    fun scaled_font_get_reference_count = cairo_scaled_font_get_reference_count(
      scaled_font : PScaledFontT
    ) : UInt32

    fun scaled_font_status = cairo_scaled_font_status(
      scaled_font : PScaledFontT
    ) : StatusT

    fun scaled_font_get_type = cairo_scaled_font_get_type(
      scaled_font : PScaledFontT
    ) : FontTypeT

    fun scaled_font_get_user_data = cairo_scaled_font_get_user_data(
      scaled_font : PScaledFontT,
      key : PUserDataKeyT
    ) : Void*

    fun scaled_font_set_user_data = cairo_scaled_font_set_user_data(
      scaled_font : PScaledFontT,
      key : PUserDataKeyT,
      user_data : Void*,
      destroy : DestroyFuncT
    ) : StatusT

    fun scaled_font_extents = cairo_scaled_font_extents(
      scaled_font : PScaledFontT,
      extents : PFontExtentsT
    ) : Void

    fun scaled_font_text_extents = cairo_scaled_font_text_extents(
      scaled_font : PScaledFontT,
      utf8 : UInt8*,
      extents : PTextExtentsT
    ) : Void

    fun scaled_font_glyph_extents = cairo_scaled_font_glyph_extents(
      scaled_font : PScaledFontT,
      glyphs : PGlyphT,
      num_glyphs : Int32,
      extents : PTextExtentsT
    ) : Void

    fun scaled_font_text_to_glyphs = cairo_scaled_font_text_to_glyphs(
      scaled_font : PScaledFontT,
      x : Float64,
      y : Float64,
      utf8 : UInt8*,
      utf8_len : Int32,
      glyphs : PGlyphT*,
      num_glyphs : Int32*,
      clusters : PTextClusterT*,
      num_clusters : Int32*,
      cluster_flags : TextClusterFlagsT*
    ) : StatusT

    fun scaled_font_get_font_face = cairo_scaled_font_get_font_face(
      scaled_font : PScaledFontT
    ) : PFontFaceT

    fun scaled_font_get_font_matrix = cairo_scaled_font_get_font_matrix(
      scaled_font : PScaledFontT,
      font_matrix : PMatrixT
    ) : Void

    fun scaled_font_get_ctm = cairo_scaled_font_get_ctm(
      scaled_font : PScaledFontT,
      ctm : PMatrixT
    ) : Void

    fun scaled_font_get_scale_matrix = cairo_scaled_font_get_scale_matrix(
      scaled_font : PScaledFontT,
      scale_matrix : PMatrixT
    ) : Void

    fun scaled_font_get_font_options = cairo_scaled_font_get_font_options(
      scaled_font : PScaledFontT,
      options : PFontOptionsT
    ) : Void

  end # lib Cairo
end # module CairoCr
