require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # Wrapper for LibCairo::PFontOptionsT
  class FontOptions
    def initialize
      @font_options = LibCairo.font_options_create
    end

    def initialize(@font_options : LibCairo::PFontOptionsT)
    end

    def finalize
      LibCairo.font_options_destroy(@font_options)
    end

    def dup : FontOptions
      FontOptions.new(LibCairo.font_options_copy(@font_options))
    end

    def status : Status
      Status.new(LibCairo.font_options_status(@font_options))
    end

    def merge(other : FontOptions)
      LibCairo.font_options_merge(@font_options, other.to_unsafe)
      self
    end

    def equals(other : FontOptions) : Bool
      LibCairo.font_options_equal(@font_options, other.to_unsafe) == 1
    end

    def hash : UInt64
      LibCairo.font_options_hash(@font_options)
    end

    def antialias : Antialias
      Antialias.new(LibCairo.font_options_get_antialias(@font_options).value)
    end

    def antialias=(antialias : Antialias)
      LibCairo.font_options_set_antialias(@font_options, LibCairo::AntialiasT.new(antialias.value))
      self
    end

    def subpixel_order : SubpixelOrder
      SubpixelOrder.new(LibCairo.font_options_get_subpixel_order(@font_options).value)
    end

    def subpixel_order=(subpixel_order : SubpixelOrder)
      LibCairo.font_options_set_subpixel_order(@font_options, LibCairo::SubpixelOrderT.new(subpixel_order.value))
      self
    end

    def hint_style : HintStyle
      HintStyle.new(LibCairo.font_options_get_hint_style(@font_options).value)
    end

    def hint_style=(hint_style : HintStyle)
      LibCairo.font_options_set_hint_style(@font_options, LibCairo::HintStyleT.new(hint_style.value))
      self
    end

    def hint_metrics : HintMetrics
      HintMetrics.new(LibCairo.font_options_get_hint_metrics(@font_options).value)
    end

    def hint_metrics=(hint_metrics : HintMetrics)
      LibCairo.font_options_set_hint_metrics(@font_options, LibCairo::HintMetricsT.new(hint_metrics.value))
      self
    end

    def to_unsafe : LibCairo::PFontOptionsT
      @font_options
    end
  end
end
