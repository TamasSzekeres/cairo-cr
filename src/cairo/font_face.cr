require "./c/lib_cairo"

module Cairo
  # `FontFace` represents a particular font at a particular weight, slant,
  # and other characteristic but no size, transformation, or size.
  #
  # A `FontFace` specifies all aspects of a font other than the size or font matrix
  # (a font matrix is used to distort a font by shearing it or scaling it unequally in the two directions).
  # A font face can be set on a `Context` by using `Context#font_face=`;
  # the size and font matrix are set with `Context#font_size=` and `Context#font_matrix=`.
  #
  # There are various types of font faces, depending on the font backend they use.
  # The type of a font face can be queried using `FontFace#type`.
  #
  # Memory management of `FontFace` is done with `FontFace#reference` and `FontFace#finalize`.
  class FontFace
    def initialize
      @font_face = LibCairo.user_font_face_create
    end

    def initialize(font_face : LibCairo::PFontFaceT)
      raise ArgumentError.new("'font_face' cannot be null.") if font_face.null?
      @font_face = font_face
    end

    # Decreases the reference count on `FontFace` by one.
    # If the result is zero, then `FontFace` and all associated resources are freed.
    # See `FontFace#reference`.
    def finalize
      LibCairo.font_face_destroy(@font_face)
    end

    # Increases the reference count on `FontFace` by one.
    # This prevents `FontFace` from being destroyed until a matching call
    # to `Context#finalize` is made.
    #
    # Use `Context#reference_count` to get the number of references to a `FontFace`.
    #
    # ###Returns
    # The referenced `FontFace`.
    def reference : FontFace
      FontFace.new(LibCairo.font_face_reference(@font_face))
    end

    # Returns the current reference count of `FontFace` .
    #
    # ###Returns
    # Tthe current reference count of `FontFace`. If the object is a nil object, 0 will be returned.
    def reference_count : UInt32
      LibCairo.font_face_get_reference_count(@font_face)
    end

    # Checks whether an error has previously occurred for this font face.
    #
    # ###Returns
    # `Status::Success` or another error such as `Status::NoMemory`.
    def status : Status
      Status.new(LibCairo.font_face_status(@font_face).value)
    end

    # This function returns the type of the backend used to create a font face.
    # See `FontType` for available types.
    #
    # ###Returns
    # The type of `FontFace`.
    def type : FontType
      FontType.new(LibCairo.font_face_get_type(@font_face).value)
    end

    # Return user data previously attached to `FontFace` using the specified key.
    # If no user data has been attached with the given key this function returns `Nil`.
    #
    # ###Parameters
    # - **key** the address of the `UserDataKey` the user data was attached to
    #
    # ###Returns
    # The user data previously attached or `Nil`.
    def user_data(key : UserDataKey) : Void*
      LibCairo.font_face_get_user_data(@font_face, key.to_unsafe)
    end

    # Attach user data to `FontFace`. To remove user data from a font face,
    # call this function with the key that was used to set it and `Nil` for data.
    #
    # ###Parameters
    # - **key** the address of a `UserDataKey` to attach the user data to
    # - **user_data** the user data to attach to the font face
    # - **destroy** a `LibCairo::DestroyFuncT` which will be called when the font
    # face is destroyed or when new user data is attached using the same key
	  #
    # ###Returns
    # `Status::Success` or `Status::NoMemory` if a slot could not be allocated for the user data.
    def set_user_data(key : UserDataKey, user_data : Void*, destroy : LibCairo::DestroyFuncT) : Status
      Status.new(LibCairo.font_face_set_user_data(@font_face, key.to_unsafe, user_data, destroy).value)
    end

    def create_scaled_font(font_matrix : Matrix, ctm : Matrix, options : FontOptions) : ScaledFont
      ScaledFont.new(LibCairo.scaled_font_create(@font_face, font_matrix.to_unsafe, ctm.to_unsafe, options.to_unsafe))
    end

    # Creates a font face from a triplet of *family*, *slant*, and *weight*.
    # These font faces are used in implementation of the the `Context` "toy" font API.
    #
    # If family is the zero-length string "", the platform-specific default family is assumed.
    # The default family then can be queried using `FontFace#family`.
    #
    # The `Context#select_font_face` function uses this to create font faces.
    # See that function for limitations and other details of toy font faces.
    #
    # ###Parameters
    # - **family** a font family name, encoded in UTF-8
    # - **slant** the slant for the font
    # - **weight** the weight for the font
    #
    # ###Returns
    # A newly created `FontFace`. Free with `FontFace#finalize` when you are done using it.
    def initialize(family : String, slant : FontSlant, weight : FontWeight)
      @font_face = LibCairo.toy_font_face_create(family.to_unsafe,
        LibCairo::FontSlantT.new(slant.value),
        LibCairo::FontWeightT.new(weight.value))
    end

    # Gets the familly name of a toy font.
    #
    # ###Returns
    # The family name. This string is owned by the font face and remains valid as long as the font face is alive (referenced).
    def family : String
      String.new(LibCairo.toy_font_face_get_family(@font_face))
    end

    # Gets the slant a toy font.
    #
    # ###Returns
    # The slant value.
    def slant : FontSlant
      FontSlant.new(LibCairo.toy_font_face_get_slant(@font_face).value)
    end

    # Gets the weight a toy font.
    #
    # ###Returns
    # The weight value.
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
