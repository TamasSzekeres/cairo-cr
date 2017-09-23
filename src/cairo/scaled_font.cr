require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # Wrapper for LibCairo::PScaledFontT
  class ScaledFont
    def initialize(font_face : FontFace, font_matrix : Matrix, ctm : Matrix, options : FontOptions)
      @scaled_font = LibCairo.scaled_font_create(font_face.to_unsafe, font_matrix.to_unsafe, ctm.to_unsafe, options.to_unsafe)
    end

    def initialize(scaled_font : LibCairo::PScaledFontT)
      raise ArgumentError.new("'scaled_font' cannot be null.") if scaled_font.null?
      @scaled_font = scaled_font
    end

    def finalize
      LibCairo.scaled_font_destroy(@scaled_font)
    end

    def reference : ScaledFont
      ScaledFont.new(LibCairo.scaled_font_reference(@scaled_font))
    end

    def reference_count : UInt32
      LibCairo.scaled_font_get_reference_count(@scaled_font)
    end

    def status : Status
      Status.new(LibCairo.scaled_font_status(@scaled_font).value)
    end

    def type : FontType
      FontType.new(LibCairo.scaled_font_get_type(@scaled_font).value)
    end

    def user_data(key : UserDataKey) : Void*
      LibCairo.scaled_font_get_user_data(@scaled_font, key.to_unsafe)
    end

    def set_user_data(key : UserDataKey, user_data : Void*, destroy : DestroyFuncT) : Status
      Status.new(LibCairo.scaled_font_set_user_data(@scaled_font, key.to_unsafe, user_data, destroy).value)
    end

    def extents : FontExtents
      LibCairo.scaled_font_extents(@scaled_font, out font_extents)
      FontExtents.new(font_extents)
    end

    def text_extents(text : String) : TextExtents
      LibCairo.scaled_font_text_extents(@scaled_font, text.to_unsafe, out text_extents)
      TextExtents.new(text_extents)
    end

    def glyph_extents(glyphs : Array(Glyph)) : TextExtents
      raise "unimplemented method"
    end

    def text_to_glyphs(x : Float64, y : Float64, text : String, glyphs : Array(Glyph), clusters : Arry(TextCluster), cluster_flags : Array(TextClusterFlags)) : Status
      raise "unimplemented method"
    end

    def font_face : FontFace
      FontFace.new(LibCairo.scaled_font_get_font_face(@scaled_font))
    end

    def font_matrix : Matrix
      LibCairo.scaled_font_get_font_matrix(@scaled_font, out matrix)
      Matrix.new(matrix)
    end

    def ctm : Matrix
      LibCairo.scaled_font_get_ctm(@scaled_font, out ctm)
      Matrix.new(ctm)
    end

    def scale_matrix : Matrix
      LibCairo.scaled_font_get_scale_matrix(@scaled_font, out matrix)
      Matrix.new(matrix)
    end

    def font_options : FontOptions
      font_options = FontOptions.new
      LibCairo.scaled_font_get_font_options(@scaled_font, font_options.to_unsafe)
      font_options
    end

    def to_unsafe : LibCairo::PScaledFontT
      @scaled_font
    end
  end
end
