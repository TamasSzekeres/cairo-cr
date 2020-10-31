require "./features"
require "../version"

module Cairo::C
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
  lib LibCairo
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
      SUCCESS = 0

      NO_MEMORY
      INVALID_RESTORE
      INVALID_POP_GROUP
      NO_CURRENT_POINT
      INVALID_MATRIX
      INVALID_STATUS
      NULL_POINTER
      INVALID_STRING
      INVALID_PATH_DATA
      READ_ERROR
      WRITE_ERROR
      SURFACE_FINISHED
      SURFACE_TYPE_MISMATCH
      PATTERN_TYPE_MISMATCH
      INVALID_CONTENT
      INVALID_FORMAT
      INVALID_VISUAL
      FILE_NOT_FOUND
      INVALID_DASH
      INVALID_DSC_COMMENT
      INVALID_INDEX
      CLIP_NOT_REPRESENTABLE
      TEMP_FILE_ERROR
      INVALID_STRIDE
      FONT_TYPE_MISMATCH
      USER_FONT_IMMUTABLE
      USER_FONT_ERROR
      NEGATIVE_COUNT
      INVALID_CLUSTERS
      INVALID_SLANT
      INVALID_WEIGHT
      INVALID_SIZE
      USER_FONT_NOT_IMPLEMENTED
      DEVICE_TYPE_MISMATCH
      DEVICE_ERROR
      INVALID_MESH_CONSTRUCTION
      DEVICE_FINISHED
      JBIG2_GLOBAL_MISSING
      PNG_ERROR
      FREETYPE_ERROR
      WIN32_GDI_ERROR
      TAG_ERROR

      LAST_STATUS
    end

    enum ContentT
      COLOR       = 0x1000
      ALPHA       = 0x2000
      COLOR_ALPHA = 0x3000
    end

    enum FormatT
      INVALID   = -1
      ARGB32    = 0
      RGB24     = 1
      A8        = 2
      A1        = 3
      RGB16_565 = 4
      RGB30     = 5
    end

    # closure, data, length -> status
    alias WriteFuncT = Void*, UInt8*, UInt32 -> StatusT

    # closire, data, length -> status
    alias ReadFuncT = Void*, UInt8*, Int32 -> StatusT

    alias PRectangleIntT = RectangleIntT*
    struct RectangleIntT
      x, y : Int32
      width, height : Int32
    end

    # Functions for manipulating state objects
    fun create = cairo_create(target : PSurfaceT) : PCairoT

    fun reference = cairo_reference(cr : PCairoT) : PCairoT

    fun destroy = cairo_destroy(cr : PCairoT) : Void

    fun get_reference_count = cairo_get_reference_count(cr:  PCairoT) : UInt32

    fun get_user_data = cairo_get_user_data(
      cr : PCairoT,
      key : PUserDataKeyT
    ) : Void*

    fun set_user_data = cairo_set_user_data(
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
      CLEAR

      SOURCE
      OVER
      IN
      OUT
      ATOP

      DEST
      DEST_OVER
      DEST_IN
      DEST_OUT
      DEST_ATOP

      XOR
      ADD
      SATURATE

      MULTIPLY
      SCREEN
      OVERLAY
      DARKEN
      LIGHTEN
      COLOR_DODGE
      COLOR_BURN
      HARD_LIGHT
      SOFT_LIGHT
      DIFFERENCE
      EXCLUSION
      HSL_HUE
      HSL_SATURATION
      HSL_COLOR
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
      ANTIALIAS_DEFAULT

      # method
      ANTIALIAS_NONE
      ANTIALIAS_GRAY
      ANTIALIAS_SUBPIXEL

      # hints
      ANTIALIAS_FAST
      ANTIALIAS_GOOD
      ANTIALIAS_BEST
    end

    fun set_antialias = cairo_set_antialias(
      cr : PCairoT,
      antialias : AntialiasT
    ) : Void

    enum FillRuleT
      WINDING
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
      BUTT
      ROUND
      SQUARE
    end

    fun set_line_cap = cairo_set_line_cap(
      cr : PCairoT,
      line_cap : LineCapT
    ) : Void

    enum LineJoinT
      MITER
      ROUND
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
    fun stroke_extents = cairo_stroke_extents(
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
      NORMAL
      ITALIC
      OBLIQUE
    end

    enum FontWeightT
      NORMAL
      BOLD
    end

    enum SubpixelOrderT
      DEFAULT
      RGB
      BGR
      VRGB
      VBGR
    end

    enum HintStyleT
      DEFAULT
      NONE
      SLIGHT
      MEDIUM
      FULL
    end

    enum HintMetricsT
      DEFAULT
      OFF
      ON
    end

    alias PFontOptionsT = Void*

    fun font_options_create = cairo_font_options_create(
    ) : PFontOptionsT

    fun font_options_copy = cairo_font_options_copy(
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
      options : PFontOptionsT,
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
      TOY
      FT
      WIN32
      QUARTZ
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

    # Toy fonts

    fun toy_font_face_create = cairo_toy_font_face_create(
      family : UInt8*,
      slant : FontSlantT,
      weight : FontWeightT
    ) : PFontFaceT

    fun toy_font_face_get_family = cairo_toy_font_face_get_family(
      font_face : PFontFaceT
    ) : UInt8*

    fun toy_font_face_get_slant = cairo_toy_font_face_get_slant(
      font_face : PFontFaceT
    ) : FontSlantT

    fun toy_font_face_get_weight = cairo_toy_font_face_get_weight(
      font_face : PFontFaceT
    ) : FontWeightT

    # User fonts

    fun user_font_face_create = cairo_user_font_face_create() : PFontFaceT

    # User-font method signatures

    # scaled_font, cr, extents -> status
    alias UserScaledFontInitFuncT = PScaledFontT, PCairoT, PFontExtentsT -> StatusT

    # scaled_font, glyph, cr, extents -> status
    alias UserScaledFontRenderGlyphFuncT = PScaledFontT, UInt64, PCairoT, PTextExtentsT -> StatusT

    # scaled_font, utf8, utf8_len, glyphs, num_glyphs, clusters, num_clusters, cluster_flags -> status
    alias UserScaledFontTextToGlyphFuncT = PScaledFontT, UInt8*, Int32, PGlyphT*, Int32*, PTextClusterT*, Int32*, TextClusterFlagsT* -> StatusT

    # scaled_font, unicode, glyph_index -> status
    alias UserScaledFontUnicodeToGlyphFuncT = PScaledFontT, UInt64, UInt64* -> StatusT

    # User-font method setters

    fun user_font_face_set_init_func = cairo_user_font_face_set_init_func(
      font_face : PFontFaceT,
      init_func : UserScaledFontInitFuncT
    ) : Void

    fun user_font_face_set_render_glyph_func = cairo_user_font_face_set_render_glyph_func(
      font_face : PFontFaceT,
      render_glyph_func : UserScaledFontRenderGlyphFuncT
    ) : Void

    fun user_font_face_set_text_to_glyphs_func = cairo_user_font_face_set_text_to_glyphs_func(
      font_face : PFontFaceT,
      text_to_glyphs_func : UserScaledFontTextToGlyphFuncT
    ) : Void

    fun user_font_face_set_unicode_to_glyph_func = cairo_user_font_face_set_unicode_to_glyph_func(
      font_face : PFontFaceT,
      unicode_to_glyph_func : UserScaledFontUnicodeToGlyphFuncT
    ) : Void

    # User-font method getters

    fun user_font_face_get_init_func = cairo_user_font_face_get_init_func(
      font_face : PFontFaceT
    ) : UserScaledFontInitFuncT

    fun user_font_face_get_render_glyph_func = cairo_user_font_face_get_render_glyph_func(
      font_face : PFontFaceT
    ) : UserScaledFontRenderGlyphFuncT

    fun user_font_face_get_text_to_glyphs_func = cairo_user_font_face_get_text_to_glyphs_func(
      font_face : PFontFaceT
    ) : UserScaledFontTextToGlyphFuncT

    fun user_font_face_get_unicode_to_glyph_func = cairo_user_font_face_get_unicode_to_glyph_func(
      font_face : PFontFaceT
    ) : UserScaledFontUnicodeToGlyphFuncT

    # Query functions

    fun get_operator = cairo_get_operator(
      cr : PCairoT
    ) : OperatorT

    fun get_source = cairo_get_source(
      cr : PCairoT
    ) : PPatternT

    fun get_tolerance = cairo_get_tolerance(
      cr : PCairoT
    ) : Float64

    fun get_antialias = cairo_get_antialias(
      cr : PCairoT
    ) : AntialiasT

    fun has_current_point = cairo_has_current_point(
      cr : PCairoT
    ) : BoolT

    fun get_current_point = cairo_get_current_point(
      cr : PCairoT,
      x : Float64*,
      y : Float64*
    ) : Void

    fun get_fill_rule = cairo_get_fill_rule(
      cr : PCairoT
    ) : FillRuleT

    fun get_line_width = cairo_get_line_width(
      cr : PCairoT
    ) : Float64

    fun get_line_cap = cairo_get_line_cap(
      cr : PCairoT
    ) : LineCapT

    fun get_line_join = cairo_get_line_join(
      cr : PCairoT
    ) : LineJoinT

    fun get_miter_limit = cairo_get_miter_limit(
      cr : PCairoT
    ) : Float64

    fun get_dash_count = cairo_get_dash_count(
      cr : PCairoT
    ) : Int32

    fun get_dash = cairo_get_dash(
      cr : PCairoT,
      dashes : Float64*,
      offset : Float64*
    ) : Void

    fun get_matrix = cairo_get_matrix(
      cr : PCairoT,
      matrix : PMatrixT
    ) : Void

    fun get_target = cairo_get_target(
      cr : PCairoT
    ) : PSurfaceT

    fun get_group_target = cairo_get_group_target(
      cr : PCairoT
    ) : PSurfaceT

    enum PathDataTypeT
      MOVE_TO
      LINE_TO
      CURVE_TO
      CLOSE_PATH
    end

    alias PPathDataHeaderT = PathDataHeaderT*
    struct PathDataHeaderT
      type : PathDataTypeT
      length : Int32
    end

    alias PPathDataPointT = PathDataPointT*
    struct PathDataPointT
      x, y : Float64
    end

    alias PPathDataT = PathDataT*
    union PathDataT
      header : PathDataHeaderT
      point : PathDataPointT
    end

    alias PPathT = PathT*
    struct PathT
      status : StatusT
      data : PPathDataT
      num_data : Int32
    end

    fun copy_path = cairo_copy_path(
      cr : PCairoT
    ) : PPathT

    fun copy_path_flat = cairo_copy_path_flat(
      cr : PCairoT
    ) : PPathT

    fun append_path = cairo_append_path(
      cr : PCairoT,
      path : PPathT
    ) : Void

    fun path_destroy = cairo_path_destroy(
      path : PPathT
    ) : Void

    # Error status queries

    fun status = cairo_status(
      cr : PCairoT
    ) : StatusT

    fun status_to_string = cairo_status_to_string(
      status : StatusT
    ) : UInt8*

    # Backend device manipulation

    fun device_reference = cairo_device_reference(
      device : PDeviceT
    ) : PDeviceT

    enum DeviceTypeT
      DRM
      GL
      SCRIPT
      XCB
      XLIB
      XML
      COGL
      WIN32

      INVALID = -1
    end

    fun device_get_type = cairo_device_get_type(
      device : PDeviceT
    ) : DeviceTypeT

    fun device_status = cairo_device_status(
      device : PDeviceT
    ) : StatusT

    fun device_acquire = cairo_device_acquire(
      device : PDeviceT
    ) : StatusT

    fun device_release = cairo_device_release(
      device : PDeviceT
    ) : Void

    fun device_flush = cairo_device_flush(
      device : PDeviceT
    ) : Void

    fun device_finish = cairo_device_finish(
      device : PDeviceT
    ) : Void

    fun device_destroy = cairo_device_destroy(
      device : PDeviceT
    ) : Void

    fun device_get_reference_count = cairo_device_get_reference_count(
      device : PDeviceT
    ) : UInt32

    fun device_get_user_data = cairo_device_get_user_data(
      device : PDeviceT,
      key : PUserDataKeyT
    ) : Void*

    fun device_set_user_data = cairo_device_set_user_data(
      device : PDeviceT,
      key : PUserDataKeyT,
      user_data : Void*,
      destroy : DestroyFuncT
    ) : StatusT

    # Surface manipulation

    fun surface_create_similar = cairo_surface_create_similar(
      other : PSurfaceT,
      content : ContentT,
      width : Int32,
      height : Int32
    ) : PSurfaceT

    fun surface_create_similar_image = cairo_surface_create_similar_image(
      other : PSurfaceT,
      format : FormatT,
      width : Int32,
      height : Int32
    ) : PSurfaceT

    fun surface_map_to_image = cairo_surface_map_to_image(
      surface : PSurfaceT,
      extents : RectangleIntT*
    ) : PSurfaceT

    fun surface_unmap_image = cairo_surface_unmap_image(
      surface : PSurfaceT,
      image : PSurfaceT
    ) : Void

    fun surface_create_for_rectangle = cairo_surface_create_for_rectangle(
      target : PSurfaceT,
      x : Float64,
      y : Float64,
      width : Float64,
      height : Float64
    ) : PSurfaceT

    enum SurfaceObserverModeT
      NORMAL = 0
      RECORD_OPERATIONS = 0x1
    end

    fun surface_create_observer = cairo_surface_create_observer(
      target : PSurfaceT,
      mode : SurfaceObserverModeT
    ) : PSurfaceT

    # observer, target, data -> void
    alias SurfaceObserverCallbackT = PSurfaceT, PSurfaceT, Void* -> Void

    fun surface_observer_add_paint_callback = cairo_surface_observer_add_paint_callback(
      abstract_surface : PSurfaceT,
      func : SurfaceObserverCallbackT,
      data : Void*
    ) : StatusT

    fun surface_observer_add_mask_callback = cairo_surface_observer_add_mask_callback(
      abstract_surface : PSurfaceT,
      func : SurfaceObserverCallbackT,
      data : Void*
    ) : StatusT

    fun surface_observer_add_fill_callback = cairo_surface_observer_add_fill_callback(
      abstract_surface : PSurfaceT,
      func : SurfaceObserverCallbackT,
      data : Void*
    ) : StatusT

    fun surface_observer_add_stroke_callback = cairo_surface_observer_add_stroke_callback(
      abstract_surface : PSurfaceT,
      func : SurfaceObserverCallbackT,
      data : Void*
    ) : StatusT

    fun surface_observer_add_glyphs_callback = cairo_surface_observer_add_glyphs_callback(
      abstract_surface : PSurfaceT,
      func : SurfaceObserverCallbackT,
      data : Void*
    ) : StatusT

    fun surface_observer_add_flush_callback = cairo_surface_observer_add_flush_callback(
      abstract_surface : PSurfaceT,
      func : SurfaceObserverCallbackT,
      data : Void*
    ) : StatusT

    fun surface_observer_add_finish_callback = cairo_surface_observer_add_finish_callback(
      abstract_surface : PSurfaceT,
      func : SurfaceObserverCallbackT,
      data : Void*
    ) : StatusT

    fun surface_observer_print = cairo_surface_observer_print(
      surface : PSurfaceT,
      write_func : WriteFuncT,
      closure : Void*
    ) : StatusT

    fun surface_observer_elapsed = cairo_surface_observer_elapsed(
      surface : PSurfaceT
    ) : Float64

    fun device_observer_print = cairo_device_observer_print(
      device : PDeviceT,
      write_func : WriteFuncT,
      closure : Void*
    ) : StatusT

    fun device_observer_elapsed = cairo_device_observer_elapsed(
      device : PDeviceT
    ) : Float64

    fun device_observer_paint_elapsed = cairo_device_observer_paint_elapsed(
      device : PDeviceT
    ) : Float64

    fun device_observer_mask_elapsed = cairo_device_observer_mask_elapsed(
      device : PDeviceT
    ) : Float64

    fun device_observer_fill_elapsed = cairo_device_observer_fill_elapsed(
      device : PDeviceT
    ) : Float64

    fun device_observer_stroke_elapsed = cairo_device_observer_stroke_elapsed(
      device : PDeviceT
    ) : Float64

    fun device_observer_glyphs_elapsed = cairo_device_observer_glyphs_elapsed(
      device : PDeviceT
    ) : Float64

    fun surface_reference = cairo_surface_reference(
      surface : PSurfaceT
    ) : PSurfaceT

    fun surface_finish = cairo_surface_finish(
      surface : PSurfaceT
    ) : Void

    fun surface_destroy = cairo_surface_destroy(
      surface : PSurfaceT
    ) : Void

    fun surface_get_device = cairo_surface_get_device(
      surface : PSurfaceT
    ) : PDeviceT

    fun surface_get_reference_count = cairo_surface_get_reference_count(
      surface : PSurfaceT
    ) : UInt32

    fun surface_status = cairo_surface_status(
      surface : PSurfaceT
    ) : StatusT

    enum SurfaceTypeT
      IMAGE
      PDF
      PS
      XLIB
      XCB
      GLITZ
      QUARTZ
      WIN32
      BEOS
      DIRECTFB
      SVG
      OS2
      WIN32_PRINTING
      QUARTZ_IMAGE
      SCRIPT
      QT
      RECORDING
      VG
      GL
      DRM
      TEE
      XML
      SKIA
      SUBSURFACE
      COGL
    end

    fun surface_get_type = cairo_surface_get_type(
      surface : PSurfaceT
    ) : SurfaceTypeT

    fun surface_get_content = cairo_surface_get_content(
      surface : PSurfaceT
    ) : ContentT

    {% if Cairo::C::HAS_PNG_FUNCTIONS %}

      fun surface_write_to_png = cairo_surface_write_to_png(
        surface : PSurfaceT,
        filename : UInt8*
      ) : StatusT

      fun surface_write_to_png_stream = cairo_surface_write_to_png_stream(
        surface : PSurfaceT,
        write_func : WriteFuncT,
        closure : Void*
      ) : StatusT

    {% end %}

    fun surface_get_user_data = cairo_surface_get_user_data(
      surface : PSurfaceT,
      key : PUserDataKeyT
    ) : Void*

    fun surface_set_user_data = cairo_surface_set_user_data(
      surface : PSurfaceT,
      key : PUserDataKeyT,
      user_data : Void*,
      destroy : DestroyFuncT
    ) : StatusT

    MIME_TYPE_JPEG = "image/jpeg"
    MIME_TYPE_PNG = "image/png"
    MIME_TYPE_JP2 = "image/jp2"
    MIME_TYPE_URI = "text/x-uri"
    MIME_TYPE_UNIQUE_ID = "application/x-cairo.uuid"
    MIME_TYPE_JBIG2 = "application/x-cairo.jbig2"
    MIME_TYPE_JBIG2_GLOBAL = "application/x-cairo.jbig2-global"
    MIME_TYPE_JBIG2_GLOBAL_ID = "application/x-cairo.jbig2-global-id"

    fun surface_get_mime_data = cairo_surface_get_mime_data(
      surface : PSurfaceT,
      mime_type : UInt8*,
      data : UInt8**,
      length : UInt64*
    ) : Void

    fun surface_set_mime_data = cairo_surface_set_mime_data(
      surface : PSurfaceT,
      mime_type : UInt8*,
      data : UInt8*,
      length : UInt64,
      destroy : DestroyFuncT,
      closure : Void*
    ) : StatusT

    fun surface_supports_mime_type = cairo_surface_supports_mime_type(
      surface : PSurfaceT,
      mime_type : UInt8*
    ) : BoolT

    fun surface_get_font_options = cairo_surface_get_font_options(
      surface : PSurfaceT,
      options : PFontOptionsT
    ) : Void

    fun surface_flush = cairo_surface_flush(
      surface : PSurfaceT
    ) : Void

    fun surface_mark_dirty = cairo_surface_mark_dirty(
      surface : PSurfaceT
    ) : Void

    fun surface_mark_dirty_rectangle = cairo_surface_mark_dirty_rectangle(
      surface : PSurfaceT,
      x : Int32,
      y : Int32,
      width : Int32,
      height : Int32
    ) : Void

    fun surface_set_device_scale = cairo_surface_set_device_scale(
      surface : PSurfaceT,
      x_scale : Float64,
      y_scale : Float64
    ) : Void

    fun surface_get_device_scale = cairo_surface_get_device_scale(
      surface : PSurfaceT,
      x_scale : Float64*,
      y_scale : Float64*
    ) : Void

    fun surface_set_device_offset = cairo_surface_set_device_offset(
      surface : PSurfaceT,
      x_offset : Float64,
      y_offset : Float64
    ) : Void

    fun surface_get_device_offset = cairo_surface_get_device_offset(
      surface : PSurfaceT,
      x_offset : Float64*,
      y_offset : Float64*
    ) : Void

    fun surface_set_fallback_resolution = cairo_surface_set_fallback_resolution(
      surface : PSurfaceT,
      x_pixels_per_inch : Float64,
      y_pixels_per_inch : Float64
    ) : Void

    fun surface_get_fallback_resolution = cairo_surface_get_fallback_resolution(
      surface : PSurfaceT,
      x_pixels_per_inch : Float64*,
      y_pixels_per_inch : Float64*
    ) : Void

    fun surface_copy_page = cairo_surface_copy_page(
      surface : PSurfaceT
    ) : Void

    fun surface_show_page = cairo_surface_show_page(
      surface : PSurfaceT
    ) : Void

    fun surface_has_show_text_glyphs = cairo_surface_has_show_text_glyphs(
      surface : PSurfaceT
    ) : BoolT

    # Image-surface functions

    fun image_surface_create = cairo_image_surface_create(
      format : FormatT,
      width : Int32,
      height : Int32
    ) : PSurfaceT

    fun format_stride_for_width = cairo_format_stride_for_width(
      format : FormatT,
      width : Int32
    ) : Int32

    fun image_surface_create_for_data = cairo_image_surface_create_for_data(
      data : UInt8*,
      format : FormatT,
      width : Int32,
      height : Int32,
      stride : Int32
    ) : PSurfaceT

    fun image_surface_get_data = cairo_image_surface_get_data(
      surface : PSurfaceT
    ) : UInt8*

    fun image_surface_get_format = cairo_image_surface_get_format(
      surface : PSurfaceT
    ) : FormatT

    fun image_surface_get_width = cairo_image_surface_get_width(
      surface : PSurfaceT
    ) : Int32

    fun image_surface_get_height = cairo_image_surface_get_height(
      surface : PSurfaceT
    ) : Int32

    fun image_surface_get_stride = cairo_image_surface_get_stride(
      surface : PSurfaceT
    ) : Int32

    {% if Cairo::C::HAS_PNG_FUNCTIONS %}

      fun image_surface_create_from_png = cairo_image_surface_create_from_png(
        filename : UInt8*
      ) : PSurfaceT

      fun image_surface_create_from_png_stream = cairo_image_surface_create_from_png_stream(
        read_func : ReadFuncT,
        closure : Void*
      ) : PSurfaceT

    {% end %}

    # Recording-surface functions

    fun recording_surface_create = cairo_recording_surface_create(
      content : ContentT,
      extents : PRectangleT
    ) : PSurfaceT

    fun recording_surface_ink_extents = cairo_recording_surface_ink_extents(
      surface : PSurfaceT,
      x0 : Float64*,
      y0 : Float64*,
      width : Float64*,
      height : Float64*
    ) : Void

    fun recording_surface_get_extents = cairo_recording_surface_get_extents(
      surface : PSurfaceT,
      extents : PRectangleT
    ) : BoolT

    # raster-source pattern (callback) functions

    # pattern, callback_data, target, extents -> surface
    alias RasterSourceAcquireFuncT = PPatternT, Void*, PSurfaceT, RectangleIntT* -> PSurfaceT;

    # pattern, callback_data, surface -> void
    alias RasterSourceReleaseFuncT = PPatternT, Void*, PSurfaceT -> Void

    # pattern, callback_data -> status
    alias RasterSourceSnapshotFuncT = PPatternT, Void* -> StatusT

    # pattern, callback_data, other -> status
    alias RasterSourceCopyFuncT = PPatternT, Void*, PPatternT -> StatusT

    # pattern, callback_data -> void
    alias RasterSourceFinishFuncT = PPatternT, Void* -> Void

    fun pattern_create_raster_source = cairo_pattern_create_raster_source(
      user_data : Void*,
      content : ContentT,
      width : Int32,
      height : Int32
    ) : PPatternT

    fun raster_source_pattern_set_callback_data = cairo_raster_source_pattern_set_callback_data(
      pattern : PPatternT,
      data : Void*
    ) : Void

    fun raster_source_pattern_get_callback_data = cairo_raster_source_pattern_get_callback_data(
      pattern : PPatternT
    ) : Void*

    fun raster_source_pattern_set_acquire = cairo_raster_source_pattern_set_acquire(
      pattern : PPatternT,
      acquire : RasterSourceAcquireFuncT,
      release : RasterSourceReleaseFuncT
    ) : Void

    fun raster_source_pattern_get_acquire = cairo_raster_source_pattern_get_acquire(
      pattern : PPatternT,
      acquire : RasterSourceAcquireFuncT*,
      release : RasterSourceReleaseFuncT*
    ) : Void

    fun raster_source_pattern_set_snapshot = cairo_raster_source_pattern_set_snapshot(
      pattern : PPatternT,
      snapshot : RasterSourceSnapshotFuncT
    ) : Void

    fun raster_source_pattern_get_snapshot = cairo_raster_source_pattern_get_snapshot(
      pattern : PPatternT,
    ) : RasterSourceSnapshotFuncT

    fun raster_source_pattern_set_copy = cairo_raster_source_pattern_set_copy(
      pattern : PPatternT,
      copy : RasterSourceCopyFuncT
    ) : Void

    fun raster_source_pattern_get_copy = cairo_raster_source_pattern_get_copy(
      pattern : PPatternT,
    ) : RasterSourceCopyFuncT

    fun raster_source_pattern_set_finish = cairo_raster_source_pattern_set_finish(
      pattern : PPatternT,
      finish : RasterSourceFinishFuncT
    ) : Void

    fun raster_source_pattern_get_finish = cairo_raster_source_pattern_get_finish(
      pattern : PPatternT,
    ) : RasterSourceFinishFuncT

    # Pattern creation functions

    fun pattern_create_rgb = cairo_pattern_create_rgb(
      red : Float64,
      green : Float64,
      blue : Float64
    ) : PPatternT

    fun pattern_create_rgba = cairo_pattern_create_rgba(
      red : Float64,
      green : Float64,
      blue : Float64,
      alpha : Float64
    ) : PPatternT

    fun pattern_create_for_surface = cairo_pattern_create_for_surface(
      surface : PSurfaceT
    ) : PPatternT

    fun pattern_create_linear = cairo_pattern_create_linear(
      x0 : Float64,
      y0 : Float64,
      x1 : Float64,
      y1 : Float64
    ) : PPatternT

    fun pattern_create_radial = cairo_pattern_create_radial(
      cx0 : Float64,
      cy0 : Float64,
      radius0 : Float64,
      cx1 : Float64,
      cy1 : Float64,
      radius1 : Float64
    ) : PPatternT

    fun pattern_create_mesh = cairo_pattern_create_mesh(
    ) : PPatternT

    fun pattern_reference = cairo_pattern_reference(
      pattern : PPatternT
    ) : PPatternT

    fun pattern_destroy = cairo_pattern_destroy(
      pattern : PPatternT
    ) : Void

    fun pattern_get_reference_count = cairo_pattern_get_reference_count(
      pattern : PPatternT
    ) : UInt32

    fun pattern_status = cairo_pattern_status(
      pattern : PPatternT
    ) : StatusT

    fun pattern_get_user_data = cairo_pattern_get_user_data(
      pattern : PPatternT,
      key : PUserDataKeyT
    ) : Void*

    fun pattern_set_user_data = cairo_pattern_set_user_data(
      pattern : PPatternT,
      key : PUserDataKeyT,
      user_data : Void*,
      destroy : DestroyFuncT
    ) : StatusT

    enum PatternTypeT
      SOLID
      SURFACE
      LINEAR
      RADIAL
      MESH
      RASTER_SOURCE
    end

    fun pattern_get_type = cairo_pattern_get_type(
      pattern : PPatternT,
    ) : PatternTypeT

    fun pattern_add_color_stop_rgb = cairo_pattern_add_color_stop_rgb(
      pattern : PPatternT,
      offset : Float64,
      red : Float64,
      green : Float64,
      blue : Float64
    ) : Void

    fun pattern_add_color_stop_rgba = cairo_pattern_add_color_stop_rgba(
      pattern : PPatternT,
      offset : Float64,
      red : Float64,
      green : Float64,
      blue : Float64,
      alpha : Float64
    ) : Void

    fun mesh_pattern_begin_patch = cairo_mesh_pattern_begin_patch(
      pattern : PPatternT,
    ) : Void

    fun mesh_pattern_end_patch = cairo_mesh_pattern_end_patch(
      pattern : PPatternT,
    ) : Void

    fun mesh_pattern_curve_to = cairo_mesh_pattern_curve_to(
      pattern : PPatternT,
      x1 : Float64,
      y1 : Float64,
      x2 : Float64,
      y2 : Float64,
      x3 : Float64,
      y3 : Float64
    ) : Void

    fun mesh_pattern_line_to = cairo_mesh_pattern_line_to(
      pattern : PPatternT,
      x : Float64,
      y : Float64
    ) : Void

    fun mesh_pattern_move_to = cairo_mesh_pattern_move_to(
      pattern : PPatternT,
      x : Float64,
      y : Float64
    ) : Void

    fun mesh_pattern_set_control_point = cairo_mesh_pattern_set_control_point(
      pattern : PPatternT,
      point_num : UInt32,
      x : Float64,
      y : Float64
    ) : Void

    fun mesh_pattern_set_corner_color_rgb = cairo_mesh_pattern_set_corner_color_rgb(
      pattern : PPatternT,
      corner_num : UInt32,
      red : Float64,
      green : Float64,
      blue : Float64
    ) : Void

    fun mesh_pattern_set_corner_color_rgba = cairo_mesh_pattern_set_corner_color_rgba(
      pattern : PPatternT,
      corner_num : UInt32,
      red : Float64,
      green : Float64,
      blue : Float64,
      alpha : Float64
    ) : Void

    fun pattern_set_matrix = cairo_pattern_set_matrix(
      pattern : PPatternT,
      matrix : PMatrixT
    ) : Void

    fun pattern_get_matrix = cairo_pattern_get_matrix(
      pattern : PPatternT,
      matrix : PMatrixT
    ) : Void

    enum ExtendT
      NONE
      REPEAT
      REFLECT
      PAD
    end

    fun pattern_set_extend = cairo_pattern_set_extend(
      pattern : PPatternT,
      extend : ExtendT
    ) : Void

    fun pattern_get_extend = cairo_pattern_get_extend(
      pattern : PPatternT,
    ) : ExtendT

    enum FilterT
      FAST
      GOOD
      BEST
      NEAREST
      BILINEAR
      GAUSSIAN
    end

    fun pattern_set_filter = cairo_pattern_set_filter(
      pattern : PPatternT,
      filter : FilterT
    ) : Void

    fun pattern_get_filter = cairo_pattern_get_filter(
      pattern : PPatternT,
    ) : FilterT

    fun pattern_get_rgba = cairo_pattern_get_rgba(
      pattern : PPatternT,
      red : Float64*,
      green : Float64*,
      blue : Float64*,
      alpha : Float64*
    ) : StatusT

    fun pattern_get_surface = cairo_pattern_get_surface(
      pattern : PPatternT,
      surface : PSurfaceT*
    ) : StatusT

    fun pattern_get_color_stop_rgba = cairo_pattern_get_color_stop_rgba(
      pattern : PPatternT,
      index : Int32,
      offset : Float64*,
      red : Float64*,
      green : Float64*,
      blue : Float64*,
      alpha : Float64*
    ) : StatusT

    fun pattern_get_color_stop_count = cairo_pattern_get_color_stop_count(
      pattern : PPatternT,
      count : Int32*
    ) : StatusT

    fun pattern_get_linear_points = cairo_pattern_get_linear_points(
      pattern : PPatternT,
      x0 : Float64*,
      y0 : Float64*,
      x1 : Float64*,
      y1 : Float64*
    ) : StatusT

    fun pattern_get_radial_circles = cairo_pattern_get_radial_circles(
      pattern : PPatternT,
      x0 : Float64*,
      y0 : Float64*,
      r0 : Float64*,
      x1 : Float64*,
      y1 : Float64*,
      r1 : Float64*
    ) : StatusT

    fun mesh_pattern_get_patch_count = cairo_mesh_pattern_get_patch_count(
      pattern : PPatternT,
      count : UInt32*
    ) : StatusT

    fun mesh_pattern_get_path = cairo_mesh_pattern_get_path(
      pattern : PPatternT,
      patch_num : UInt32
    ) : PPathT

    fun mesh_pattern_get_corner_color_rgba = cairo_mesh_pattern_get_corner_color_rgba(
      pattern : PPatternT,
      patch_num : UInt32,
      corner_num : UInt32,
      red : Float64*,
      green : Float64*,
      blue : Float64*,
      alpha : Float64*
    ) : StatusT

    fun mesh_pattern_get_control_point = cairo_mesh_pattern_get_control_point(
      pattern : PPatternT,
      patch_num : UInt32,
      point_num : UInt32,
      x : Float64*,
      y : Float64*
    ) : StatusT

    # Matrix functions

    fun matrix_init = cairo_matrix_init(
      matrix : PMatrixT,
      xx : Float64,
      yx : Float64,
      xy : Float64,
      yy : Float64,
      x0 : Float64,
      y0 : Float64
    ) : Void

    fun matrix_init_identity = cairo_matrix_init_identity(
      matrix : PMatrixT,
    ) : Void

    fun matrix_init_translate = cairo_matrix_init_translate(
      matrix : PMatrixT,
      tx : Float64,
      ty : Float64
    ) : Void

    fun matrix_init_scale = cairo_matrix_init_scale(
      matrix : PMatrixT,
      sx : Float64,
      sy : Float64
    ) : Void

    fun matrix_init_rotate = cairo_matrix_init_rotate(
      matrix : PMatrixT,
      radians : Float64
    ) : Void

    fun matrix_translate = cairo_matrix_translate(
      matrix : PMatrixT,
      tx : Float64,
      ty : Float64
    ) : Void

    fun matrix_scale = cairo_matrix_scale(
      matrix : PMatrixT,
      sx : Float64,
      sy : Float64
    ) : Void

    fun matrix_rotate = cairo_matrix_rotate(
      matrix : PMatrixT,
      radians : Float64
    ) : Void

    fun matrix_invert = cairo_matrix_invert(
      matrix : PMatrixT,
    ) : StatusT

    fun matrix_multiply = cairo_matrix_multiply(
      result : PMatrixT,
      a : PMatrixT,
      b : PMatrixT
    ) : Void

    fun matrix_transform_distance = cairo_matrix_transform_distance(
      matrix : PMatrixT,
      dx : Float64*,
      dy : Float64*
    ) : Void

    fun matrix_transform_point = cairo_matrix_transform_point(
      matrix : PMatrixT,
      x : Float64*,
      y : Float64*
    ) : Void

    # Region functions

    alias PRegionT = RegionT*
    alias RegionT = Void*

    enum RegionOverlapT
      IN   # completely inside region
      OUT  # completely outside region
      PART # partly inside region
    end

    fun region_create = cairo_region_create() : PRegionT

    fun region_create_rectangle = cairo_region_create_rectangle(
      rectangle : RectangleIntT*
    ) : PRegionT

    fun region_create_rectangles = cairo_region_create_rectangles(
      rects : RectangleIntT*,
      count : Int32
    ) : PRegionT

    fun region_copy = cairo_region_copy(
      original : PRegionT
    ) : PRegionT

    fun region_reference = cairo_region_reference(
      region : PRegionT
    ) : PRegionT

    fun region_destroy = cairo_region_destroy(
      region : PRegionT
    ) : Void

    fun region_equal = cairo_region_equal(
      a : PRegionT,
      b : PRegionT
    ) : BoolT

    fun region_status = cairo_region_status(
      region : PRegionT
    ) : StatusT

    fun region_get_extents = cairo_region_get_extents(
      region : PRegionT,
      extents : RectangleIntT*
    ) : Void

    fun region_num_rectangles = cairo_region_num_rectangles(
      region : PRegionT
    ) : Int32

    fun region_get_rectangle = cairo_region_get_rectangle(
      region : PRegionT,
      nth : Int32,
      rectangle : RectangleIntT*
    ) : Void

    fun region_is_empty = cairo_region_is_empty(
      region : PRegionT
    ) : BoolT

    fun region_contains_rectangle = cairo_region_contains_rectangle(
      region : PRegionT,
      rectangle : RectangleIntT*
    ) : RegionOverlapT

    fun region_contains_point = cairo_region_contains_point(
      region : PRegionT,
      x : Int32,
      y : Int32
    ) : BoolT

    fun region_translate = cairo_region_translate(
      region : PRegionT,
      dx : Int32,
      dy : Int32
    ) : Void

    fun region_subtract = cairo_region_subtract(
      dst : PRegionT,
      other : PRegionT
    ) : StatusT

    fun region_subtract_rectangle = cairo_region_subtract_rectangle(
      dst : PRegionT,
      rectangle : RectangleIntT*
    ) : StatusT

    fun region_intersect = cairo_region_intersect(
      dst : PRegionT,
      other : PRegionT
    ) : StatusT

    fun region_intersect_rectangle = cairo_region_intersect_rectangle(
      dst : PRegionT,
      rectangle : RectangleIntT*
    ) : StatusT

    fun region_union = cairo_region_union(
      dst : PRegionT,
      other : PRegionT
    ) : StatusT

    fun region_union_rectangle = cairo_region_union_rectangle(
      dst : PRegionT,
      rectangle : RectangleIntT*
    ) : StatusT

    fun region_xor = cairo_region_xor(
      dst : PRegionT,
      other : PRegionT
    ) : StatusT

    fun region_xor_rectangle = cairo_region_xor_rectangle(
      dst : PRegionT,
      rectangle : RectangleIntT*
    ) : StatusT

    # Functions to be used while debugging (not intended for use in production code)
    fun debug_reset_static_data = cairo_debug_reset_static_data() : Void

  end # lib LibCairo
end # module Cairo::C
