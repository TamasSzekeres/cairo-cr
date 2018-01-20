module Cairo
  struct RGBA
    property red : Float64
    property green : Float64
    property blue : Float64
    property alpha : Float64

    def initialize(@red : Float64, @green : Float64, @blue : Float64, @alpha : Float64)
    end
  end
end
