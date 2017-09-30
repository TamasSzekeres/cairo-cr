require "./c/lib_cairo"

module Cairo
  # Wrapper for LibCairo::PFontFaceT
  class FontFace
    def initialize
      @font_face = LibCairo.user_font_face_create
    end

    def initialize(font_face : LibCairo::PFontFaceT)
      raise ArgumentError.new("'font_face' cannot be null.") if font_face.null?
      @font_face = font_face
    end

    def finalize
      LibCairo.font_face_destroy(@font_face)
    end

    def reference : FontFace
      FontFace.new(LibCairo.font_face_reference(@font_face))
    end

    def reference_count : UInt32
      LibCairo.font_face_get_reference_count(@font_face)
    end

    def status : Status
      Status.new(LibCairo.font_face_status(@font_face).value)
    end

    def type : FontType
      FontType.new(LibCairo.font_face_get_type(@font_face).value)
    end

    def user_data(key : UserDataKey) : Void*
      LibCairo.font_face_get_user_data(@font_face, key.to_unsafe)
    end

    def set_user_data(key : UserDataKey, user_data : Void*, destroy : LibCairo::DestroyFuncT) : Status
      Status.new(LibCairo.font_face_set_user_data(@font_face, key.to_unsafe, user_data, destroy).value)
    end

    def create_scaled_font(font_matrix : Matrix, ctm : Matrix, options : FontOptions) : ScaledFont
      ScaledFont.new(LibCairo.scaled_font_create(@font_face, font_matrix.to_unsafe, ctm.to_unsafe, options.to_unsafe))
    end

    # Create Toy Font Face
    def initialize(family : String, slant : FontSlant, weight : FontWeight)
      @font_face = LibCairo.toy_font_face_create(family.to_unsafe,
        LibCairo::FontSlantT.new(slant.value),
        LibCairo::FontWeightT.new(weight.value))
    end

    def family : String
      String.new(LibCairo.toy_font_face_get_family(@font_face))
    end

    def slant : FontSlant
      FontSlant.new(LibCairo.toy_font_face_get_slant(@font_face).value)
    end

    def weight : FontWeight
      FontWeight.new(LibCairo.toy_font_face_get_weight(@font_face).value)
    end

    def init_func : LibCairo::UserScaledFontInitFuncT
      LibCairo.user_font_face_get_init_func(@font_face)
    end

    def init_func=(init_func : LibCairo::UserScaledFontInitFuncT)
      LibCairo.user_font_face_set_init_func(@font_face, init_func)
      self
    end

    def render_glyph_func : LibCairo::UserScaledFontRenderGlyphFuncT
      LibCairo.user_font_face_get_render_glyph_func(@font_face)
    end

    def render_glyph_func=(render_glyph_func : LibCairo::UserScaledFontRenderGlyphFuncT)
      LibCairo.user_font_face_set_render_glyph_func(@font_face, render_glyph_func)
      self
    end

    def text_to_glyphs_func : LibCairo::UserScaledFontTextToGlyphFuncT
      LibCairo.user_font_face_get_text_to_glyphs_func(@font_face)
    end

    def text_to_glyphs_func=(text_to_glyphs_func : LibCairo::UserScaledFontTextToGlyphFuncT)
      LibCairo.user_font_face_set_text_to_glyphs_func(@font_face, text_to_glyphs_func)
      self
    end

    def user_font_face_get_unicode_to_glyph_func : LibCairo::UserScaledFontUnicodeToGlyphFuncT
      LibCairo.user_font_face_get_unicode_to_glyph_func(@font_face)
    end

    def unicode_to_glyph_func=(unicode_to_glyph_func : LibCairo::UserScaledFontUnicodeToGlyphFuncT)
      LibCairo.user_font_face_set_unicode_to_glyph_func(@font_face, unicode_to_glyph_func)
      self
    end

    def to_unsafe : LibCairo::PFontFaceT
      @font_face
    end
  end
end
