require "./c/lib_cairo"

module Cairo
  include Cairo::C

  class Context
    def initialize(target : Surface)
      @cairo = LibCairo.create(target.to_unsafe)
    end

    def initialize(cairo : PCairoT)
      raise ArgumentError.new("'cairo' cannot be null") if cairo.null?
      @cairo = cairo
    end

    def finalize
      LibCairo.destroy(@cairo)
    end

    def self.version : Int32
      LibCairo.version
    end

    def self.version_string : String
      String.new LibCairo.version_string
    end

    def reference : Context
      Context.new LibCairo.reference(@cairo)
    end

    def reference_count : UInt32
      LibCairo.get_reference_count(@cairo)
    end

    def user_data(key : UserDataKey) : Void*
      LibCairo.get_user_data(@cairo, key.to_unsafe)
    end

    def set_user_data(key : UserDataKey, user_data : Void*, destroy : LibCairo::DestroyFuncT) : Status
      LibCairo.set_user_data(@cairo, key.to_unsafe, user_data, destroy)
      self
    end

    def save
      LibCairo.save(@cairo)
      self
    end

    def restore
      LibCairo.restore(@cairo)
      self
    end

    def push_group
      LibCairo.push_group(@cairo)
      self
    end

    def push_group_with_content(content : Content)
      LibCairo.push_group_with_content(@cairo, LibCairo::ContentT.new content.value)
      self
    end

    def pop_group : Pattern
      Pattern.new(LibCairo.pop_group(@cairo))
    end

    def pop_group_to_source : Context
      Context.new(LibCairo.pop_group_to_source(@cairo))
    end

    def operator=(op : Operator)
      LibCairo.set_operator(@cairo, LibCairo::OperatorT.new op.value)
      self
    end

    def source=(source : Pattern)
      LibCairo.set_source(@cairo, source.to_unsafe)
      self
    end

    def set_source_rgb(red : Float64, green : Float64, blue : Float64)
      LibCairo.set_source_rgb(@cairo, red, green, blue)
      self
    end

    def set_source_rgba(red : Float64, green : Float64, blue : Float64, alpha : Float64)
      LibCairo.set_source_rgba(@cairo, red, green, blue, alpha)
      self
    end

    def set_source_surface(surface : Surface, x : Float64, y : Float64)
      LibCairo.set_source_surface(surface.to_unsafe, x, y)
      self
    end

    def tolerance=(tolerance : Float64)
      LibCairo.set_tolerance(@cairo, tolerance)
      self
    end

    def antialias=(antialias : Antialias)
      LibCairo.set_antialias(@cairo, LibCairo::AntialiasT.new antialias.value)
      self
    end

    def fill_rule=(fill_rule : FillRule)
      LibCairo.set_fill_rule(@cairo, LibCairo::FillRuleT.new fill_rule.value)
      self
    end

    def line_width=(width : Float64)
      LibCairo.set_line_width(@cairo, width)
      self
    end

    def line_cap=(line_cap : LineCap)
      LibCairo.set_line_cap(@cairo, LibCairo::LineCapT.new line_cap.value)
      self
    end

    def line_join=(line_join : LineJoin)
      LibCairo.set_line_join(@cairo, LibCairo::LineJoinT.new line_join.value)
      self
    end

    def set_dash(dashes : Array(Float64), offset : Float64)
      LibCairo.set_dash(@cairo, dashes.to_unsafe, dashes.size, offset)
      self
    end

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

    def paint
      LibCairo.paint(@cairo)
      self
    end

    def paint_with_alpha(alpha : Float64)
      LibCairo.paint_with_alpha(@cairo, alpha)
      self
    end

    def mask(pattern : Pattern)
      LibCairo.mask(@cairo, pattern.to_unsafe)
      self
    end

    def mask_surface(surface : Surface, surface_x : Float64, surface_y : Float64)
      LibCairo.mask_surface(surface.to_unsafe, surface_x, surface_y)
      self
    end

    def stroke
      LibCairo.stroke(@cairo)
      self
    end

    def stroke_preserve
      LibCairo.stroke_preserve(@cairo)
      self
    end

    def fill
      LibCairo.fill(@cairo)
      self
    end

    def fill_preserve
      LibCairo.fill_preserve(@cairo)
      self
    end

    def copy_page
      LibCairo.copy_page(@cairo)
      self
    end

    def show_page
      LibCairo.show_page(@cairo)
      self
    end

    def in_stroke(x : Float64, y : Float64) : Bool
      LibCairo.in_stroke(@cairo, x, y) == 1
    end

    def in_stroke(p : Point) : Bool
      LibCairo.in_stroke(@cairo, p.x, p.y) == 1
    end

    def in_fill(x : Float64, y : Float64) : Bool
      LibCairo.in_fill(@cairo, x, y) == 1
    end

    def in_fill(p : Point) : Bool
      LibCairo.in_fill(@cairo, p.x, p.y) == 1
    end

    def in_clip(x : Float64, y : Float64) : Bool
      LibCairo.in_clip(@cairo, x, y) == 1
    end

    def in_clip(p : Point) : Bool
      LibCairo.in_clip(@cairo, p.x, p.y) == 1
    end

    def stroke_extents : Extents
      LibCairo.stroke_extents(@cairo, out x1, out y1, out x2, out y2)
      Extents.new(x1, y1, x2, y2)
    end

    def fill_extents(x1 : Float64, y1 : Float64, x2 : Float64, y2 : Float64)
      LibCairo.fill_extents(@cairo, x1, y1, x2, y2)
      self
    end

    def fill_extents(p1 : Point, p2 : Point)
      LibCairo.fill_extents(@cairo, p1.x, p1.y, p2.x, p2.y)
      self
    end

    def fill_extents(extents : Extents)
      LibCairo.fill_extents(@cairo, extents.x1, extents.y1, extents.x2, extents.y2)
      self
    end

    def reset_clip
      LibCairo.reset_clip(@cairo)
      self
    end

    def clip
      LibCairo.clip(@cairo)
      self
    end

    def clip_preserve
      LibCairo.clip_preserve(@cairo)
      self
    end

    def clip_extents : Extents
      LibCairo.clip_extents(@cairo, out x1, out y1, out x2, out y2)
      Extents.new(x1, y1, x2, y2)
    end

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
      font_face = FontFace.new
      LibCairo.get_font_face(@cairo, font_face.to_unsafe)
      font_face
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
      FontExtents.new(LibCairo.font_extents(@cairo))
    end

    # Query functions

    def operator : Operator
      Operator.new(LibCairo.get_operator(@cairo).value)
    end

    def source : Pattern
      Pattern.new(LibCairo.get_source(@cairo))
    end

    def tolerance : Float64
      LibCairo.get_tolerance(@cairo)
    end

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

    def fill_rule : FillRule
      FillRule.new(LibCairo.get_fill_rule(@cairo).value)
    end

    def line_width : Float64
      LibCairo.get_line_width(@cairo)
    end

    def line_cap : LineCap
      LineCap.new(LibCairo.get_line_cap(@cairo).value)
    end

    def line_join : LineJoin
      LineJoin.new(LibCairo.get_line_join(@cairo).value)
    end

    def miter_limit : Float64
      LibCairo.get_miter_limit(@cairo)
    end

    def dash_count : Int32
      LibCairo.get_dash_count(@cairo)
    end

    def dash : NamedTuple(dashes: Float64, offset: Float64)
      LibCairo.get_dash(@cairo, out dashes, out offset)
      {dashes: dashes, offset: offset}
    end

    def matrix : Matrix
      LibCairo.get_matrix(@cairo, out matrix)
      Matrix.new(matrix)
    end

    def target : Surface
      Surface.new(LibCairo.get_target(@cairo))
    end

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

    def status : Status
      Status.new(LibCairo.status(@cairo).value)
    end

    def to_unsafe : LibCairo::PCairoT
      @cairo
    end
  end
end
