module Cairo
  struct ColorStop
    property offset : Float64
    property rgba : RGBA

    def initialize(@offset : Float64, @rgba : RGBA)
    end

    def initialize(@offset : Float64, red : Float64, green : Float64, blue : Float64, alpha : Float64)
      @rgba = RGBA.new(red, green, blue, alpha)
    end

    def red
      @rgba.red
    end

    def red=(red: Float64)
      @rgba.red = red
    end

    def green
      @rgba.green
    end

    def green=(green: Float64)
      @rgba.green = green
    end

    def blue
      @rgba.blue
    end

    def blue=(blue: Float64)
      @rgba.blue = blue
    end

    def alpha
      @rgba.alpha
    end

    def alpha=(alpha: Float64)
      @rgba.alpha = alpha
    end
  end
end
