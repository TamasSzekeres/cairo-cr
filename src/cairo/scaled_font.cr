require "./c/lib_cairo"
require "./glyph_array"
require "./text_cluster_array"

module Cairo
  include Cairo::C

  # A `ScaledFont` is a font scaled to a particular size and device resolution.
  # A `ScaledFont` is most useful for low-level font usage where a library or
  # application wants to cache a reference to a scaled font to speed up the computation of metrics.
  #
  # There are various types of scaled fonts, depending on the font backend they use.
  # The type of a scaled font can be queried using `ScaledFont#type`.
  #
  # Memory management of `ScaledFont` is done with `ScaledFont#reference` and `ScaledFont#finalize`.
  class ScaledFont
    # Creates a `ScaledFont` object from a font face and matrices that describe the size of the font and the environment in which it will be used.
    #
    # ###Parameters
    #
    # - **font_face** a `FontFace`
    # - **font_matrix** font space to user space transformation matrix for the font.
    # In the simplest case of a N point font, this matrix is just a scale by N,
    # but it can also be used to shear the font or stretch it unequally along the two axes. See `Context#font_matrix=`.
    # - **ctm** user to device transformation matrix with which the font will be used.
    # - **options** options to use when getting metrics for the font and rendering with it.
    #
    # ###Returns
    # A newly created `ScaledFont`. Destroy with `ScaledFont#finalize`.
    def initialize(font_face : FontFace, font_matrix : Matrix, ctm : Matrix, options : FontOptions)
      @scaled_font = LibCairo.scaled_font_create(font_face.to_unsafe, font_matrix.to_unsafe, ctm.to_unsafe, options.to_unsafe)
    end

    def initialize(scaled_font : LibCairo::PScaledFontT)
      raise ArgumentError.new("'scaled_font' cannot be null.") if scaled_font.null?
      @scaled_font = scaled_font
    end

    # Decreases the reference count on font by one. If the result is zero,
    # then font and all associated resources are freed. See `ScaledFont#reference`.
    def finalize
      LibCairo.scaled_font_destroy(@scaled_font)
    end

    # Increases the reference count on `ScaledFont` by one. This prevents scaled_font from being destroyed
    # until a matching call to `ScaledFont#finalize` is made.
    #
    # Use `ScaledFont#reference_count` to get the number of references to a `ScaledFont`.
    #
    # ###Returns
    # The referenced `ScaledFont`.
    def reference : ScaledFont
      ScaledFont.new(LibCairo.scaled_font_reference(@scaled_font))
    end

    # Returns the current reference count of `ScaledFont`.
    #
    # ###Returns
    # The current reference count of `ScaledFont`. If the object is a *nil* object, 0 will be returned.
    def reference_count : UInt32
      LibCairo.scaled_font_get_reference_count(@scaled_font)
    end

    # Checks whether an error has previously occurred for this `ScaledFont`.
    #
    # ###Returns
    # `Status::Success` or another error such as `Status::NoMemory`.
    def status : Status
      Status.new(LibCairo.scaled_font_status(@scaled_font).value)
    end

    # This function returns the type of the backend used to create a scaled font.
    # See `FontType` for available types. However, this function never returns `FontType::Toy`.
    #
    # ###Returns
    # The type of `ScaledFont`.
    def type : FontType
      FontType.new(LibCairo.scaled_font_get_type(@scaled_font).value)
    end

    # Return user data previously attached to `ScaledFont` using the specified key.
    # If no user data has been attached with the given key this function returns *Nil*.
    #
    # ###Parameters
    # - **key** the address of the `UserDataKey` the user data was attached to
    #
    # ###Returns
    # The user data previously attached or *Nil*.
    def user_data(key : UserDataKey) : Void*
      LibCairo.scaled_font_get_user_data(@scaled_font, key.to_unsafe)
    end

    # Attach user data to `ScaledFont`. To remove user data from a surface,
    # call this function with the key that was used to set it and *Nil* for data .
    #
    # ###Parameters
    # - **key** the address of a `UserDataKey` to attach the user data to
    # - **user_data** the user data to attach to the `ScaledFont`
    # - **destroy** a `DestroyFuncT` which will be called when the `Context` is destroyed or when new user data is attached using the same key.
    #
    # ###Returns
    # `Status::Success` or `Status::NoMemory` if a slot could not be allocated for the user data.
    def set_user_data(key : UserDataKey, user_data : Void*, destroy : DestroyFuncT) : Status
      Status.new(LibCairo.scaled_font_set_user_data(@scaled_font, key.to_unsafe, user_data, destroy).value)
    end

    # Gets the metrics for a `ScaledFont`.
    #
    # ###Returns
    # A `FontExtents` which to store the retrieved extents.
    def extents : FontExtents
      LibCairo.scaled_font_extents(@scaled_font, out font_extents)
      FontExtents.new(font_extents)
    end

    # Gets the extents for a string of text. The extents describe a user-space rectangle
    # that encloses the "inked" portion of the text drawn at the origin (0,0)
    # (as it would be drawn by `Context#show_text` if the cairo graphics state were set
    # to the same `font_face`, `font_matrix`, `ctm`, and `font_options`). Additionally,
    # the `x_advance` and `y_advance` values indicate the amount by which the current point would be advanced by `Context#show_text`.
    #
    # NOTE that whitespace characters do not directly contribute to the size of the rectangle
    # (`extents.width` and `extents.height`). They do contribute indirectly by changing the position
    # of non-whitespace characters. In particular, trailing whitespace characters are likely to not affect
    # the size of the rectangle, though they will affect the `x_advance` and `y_advance` values.
    #
    # ###Parameters
    # - **text** string of text
    #
    # ###Returns
    # A `TextExtents` which to store the retrieved extents.
    def text_extents(text : String) : TextExtents
      LibCairo.scaled_font_text_extents(@scaled_font, text.to_unsafe, out text_extents)
      TextExtents.new(text_extents)
    end

    # Gets the extents for an array of glyphs. The extents describe a user-space rectangle
    # that encloses the "inked" portion of the glyphs, (as they would be drawn by `Context#show_glyphs`
    # if the cairo graphics state were set to the same `font_face`, `font_matrix`, `ctm`, and `font_options`).
    # Additionally, the `x_advance` and `y_advance` values indicate the amount by which the current
    # point would be advanced by `Context#show_glyphs`.
    #
    # NOTE that whitespace glyphs do not contribute to the size of the rectangle (`extents.width` and `extents.height`).
    #
    # ###Parameters
    # - **glyphs** an array of glyph IDs with X and Y offsets.
    #
    # ###Returns
    # A `TextExtents` which to store the retrieved extents.
    def glyph_extents(glyphs : GlyphArray) : TextExtents
      LibCairo.glyph_extents(@scaled_font, glyphs.to_unsafe, glyphs.size, out extents)
      TextExtents.new(extents)
    end

    # Converts UTF-8 text to an array of glyphs.
    #
    # ###Parameters
    # - **x** X position to place first glyph
    # - **y** Y position to place first glyph
    # - **text** a string of text encoded in UTF-8
    #
    # ###Returns
    # - **glyphs** array of glyphs to fill
    # - **clusters** array of cluster mapping information to fill
    # - **cluster_flags** cluster flags corresponding to the output clusters
    # - **status** `Status::Success` upon success, or an error status if the input values are wrong or if conversion failed.
    # If the input values are correct but the conversion failed, the error status is also set on `ScaledFont`.
    def text_to_glyphs(x : Float64, y : Float64, text : String) : NamedTuple(glyphs: GlyphArray, clusters: TextClusterArray, cluster_flags: TextClusterFlags, status: Status)
      status = LibCairo.scaled_font_text_to_glyphs(
        reference.to_unsafe, x, y, text.to_unsafe, text.size,
        out glyphs, out num_glyphs, out clusters, out num_clusters, out cluster_flags)
      {
        glyphs: GlyphArray.new(glyphs, num_glyphs),
        clusters: TextClusterArray.new(clusters, num_clusters),
        cluster_flags: TextClusterFlags.new(cluster_flags.value),
        status: Status.new(status.value)
      }
    end

    # Gets the font face that this scaled font uses. This might be the font face passed to `ScaledFont#initialize`,
    # but this does not hold true for all possible cases.
    #
    # ###Returns
    # The `FontFace` with which `ScaledFont` was created. This object is owned by cairo.
    # To keep a reference to it, you must call `ScaledFont#reference`.
    def font_face : FontFace
      FontFace.new(LibCairo.scaled_font_get_font_face(@scaled_font))
    end

    # Stores the font matrix with which scaled_font was created into matrix.
    #
    # ###Returns
    # The value for the matrix.
    def font_matrix : Matrix
      LibCairo.scaled_font_get_font_matrix(@scaled_font, out matrix)
      Matrix.new(matrix)
    end

    # Stores the CTM with which `ScaledFont` was created into *ctm*.
    # NOTE that the translation offsets *(x0, y0)* of the CTM are ignored by `ScaledFont#initialize`.
    # So, the matrix this function returns always has *0,0* as *x0,y0*.
    #
    # ###Returns
    # The value for the CTM.
    def ctm : Matrix
      LibCairo.scaled_font_get_ctm(@scaled_font, out ctm)
      Matrix.new(ctm)
    end

    # Stores the scale matrix of `ScaledFont` into matrix.
    # The scale matrix is product of the font matrix and the *ctm* associated with the scaled font,
    # and hence is the matrix mapping from font space to device space.
    #
    # ###Returns
    # The value for the matrix.
    def scale_matrix : Matrix
      LibCairo.scaled_font_get_scale_matrix(@scaled_font, out matrix)
      Matrix.new(matrix)
    end

    # Stores the font options with which `ScaledFont` was created into options.
    #
    # ###Returns
    # The value for the font options.
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
