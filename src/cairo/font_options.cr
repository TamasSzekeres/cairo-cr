require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # The font options specify how fonts should be rendered.
  # Most of the time the font options implied by a surface are just right and do not need any changes,
  # but for pixel-based targets tweaking font options may result in superior output on a particular display.
  class FontOptions
    # Allocates a new font options object with all options initialized to default values.
    #
    # ###Returns
    # A newly allocated `FontOptions`. Free with `FontOptions#finalize`.
    # This function always returns a valid pointer; if memory cannot be allocated,
    # then a special error object is returned where all operations on the object do nothing.
    # You can check for this with `FontOptions#status`.
    def initialize
      @font_options = LibCairo.font_options_create
    end

    def initialize(@font_options : LibCairo::PFontOptionsT)
    end

    # Destroys a `FontOptions` object created with `FontOptions#initialize` or `FontOptions#dup`.
    def finalize
      LibCairo.font_options_destroy(@font_options)
    end

    # Allocates a new font options object copying the option values from original.
    #
    # ###Returns
    # A newly allocated `FontOptions`. Free with `FontOptions#finalize`.
    # This function always returns a valid pointer; if memory cannot be allocated,
    # then a special error object is returned where all operations on the object do nothing.
    # You can check for this with `FontOptions#status`.
    def dup : FontOptions
      FontOptions.new(LibCairo.font_options_copy(@font_options))
    end

    # Checks whether an error has previously occurred for this font options object.
    #
    # ###Returns
    # `Status::Success` or `Status::NoMemory`.
    def status : Status
      Status.new(LibCairo.font_options_status(@font_options))
    end

    # Merges non-default options from other into options, replacing existing values.
    # This operation can be thought of as somewhat similar to compositing other onto options with the operation of `Operator::Over`.
    #
    # ###Parameters
    # - **other** another `FontOptions`
    def merge(other : FontOptions)
      LibCairo.font_options_merge(@font_options, other.to_unsafe)
      self
    end

    # Compares two font options objects for equality.
    #
    # ###Parameters
    # - **other** another `FontOptinos`
    #
    # ###Returns
    # `true` if all fields of the two font options objects match. Note that this function will return `false` if either object is in error.
    def equals(other : FontOptions) : Bool
      LibCairo.font_options_equal(@font_options, other.to_unsafe) == 1
    end

    # Compute a hash for the font options object;
    # this value will be useful when storing an object containing a `FontOptions` in a hash table.
    #
    # ###Returns
    # The hash value for the font options object. The return value can be cast to a 32-bit type if a 32-bit hash value is needed.
    def hash : UInt64
      LibCairo.font_options_hash(@font_options)
    end

    # Gets the antialiasing mode for the font options object.
    #
    # ###Returns
    # The antialiasing mode.
    def antialias : Antialias
      Antialias.new(LibCairo.font_options_get_antialias(@font_options).value)
    end

    # Sets the antialiasing mode for the font options object.
    # This specifies the type of antialiasing to do when rendering text.
    #
    # ###Parameters
    # - **antialias** the new antialiasing mode
    def antialias=(antialias : Antialias)
      LibCairo.font_options_set_antialias(@font_options, LibCairo::AntialiasT.new(antialias.value))
      self
    end

    # Gets the subpixel order for the font options object.
    # See the documentation for `SubpixelOrder` for full details.
    #
    # ###Returns
    # The subpixel order for the font options object.
    def subpixel_order : SubpixelOrder
      SubpixelOrder.new(LibCairo.font_options_get_subpixel_order(@font_options).value)
    end

    # Sets the subpixel order for the font options object.
    # The subpixel order specifies the order of color elements within each pixel on the display device
    # when rendering with an antialiasing mode of `Antialias::Subpixel`.
    # See the documentation for `SubpixelOrder` for full details.
    #
    # ###Parameters
    # - **subpixel_order** the new subpixel order
    def subpixel_order=(subpixel_order : SubpixelOrder)
      LibCairo.font_options_set_subpixel_order(@font_options, LibCairo::SubpixelOrderT.new(subpixel_order.value))
      self
    end

    # Gets the hint style for font outlines for the font options object.
    # See the documentation for `HintStyle` for full details.
    #
    # ###Returns
    # The hint style for the font options object.
    def hint_style : HintStyle
      HintStyle.new(LibCairo.font_options_get_hint_style(@font_options).value)
    end

    # Sets the hint style for font outlines for the font options object.
    # This controls whether to fit font outlines to the pixel grid, and if so,
    # whether to optimize for fidelity or contrast.
    # See the documentation for `HintStyle` for full details.
    #
    # ###Parameters
    # - **hint_style** the new hint style
    def hint_style=(hint_style : HintStyle)
      LibCairo.font_options_set_hint_style(@font_options, LibCairo::HintStyleT.new(hint_style.value))
      self
    end

    # Gets the metrics hinting mode for the font options object.
    # See the documentation for `HintMetrics` for full details.
    #
    # ###Returns
    # The metrics hinting mode for the font options object.
    def hint_metrics : HintMetrics
      HintMetrics.new(LibCairo.font_options_get_hint_metrics(@font_options).value)
    end

    # Sets the metrics hinting mode for the font options object.
    # This controls whether metrics are quantized to integer values in device units.
    # See the documentation for `HintMetrics` for full details.
    #
    # ###Parameters
    # - **hint_metrics** the new metrics hinting mode
    def hint_metrics=(hint_metrics : HintMetrics)
      LibCairo.font_options_set_hint_metrics(@font_options, LibCairo::HintMetricsT.new(hint_metrics.value))
      self
    end

    # Gets the OpenType font variations for the font options object.
    # See `FontOptions#variations`= for details about the string format.
    #
    # ###Returns
    # The font variations for the font options object.
    # The returned string belongs to the options and must not be modified.
    # It is valid until either the font options object is destroyed or the font variations in this object
    # is modified with `FontOptions#variations=`.
    def variations : String
      String.new(LibCairo.font_options_get_variations(@font_options))
    end

    # Sets the OpenType font variations for the font options object.
    # Font variations are specified as a string with a format that is similar to the CSS font-variation-settings.
    # The string contains a comma-separated list of axis assignments,
    # which each assignment consists of a 4-character axis name and a value, separated by whitespace and optional equals sign.
    #
    # ###Parameters
    # - **variations** the new font variations
    def variations=(variation : String)
      LibCairo.font_options_set_variations(@font_options, variations.to_unsafe)
      self
    end

    def to_unsafe : LibCairo::PFontOptionsT
      @font_options
    end
  end
end
