require "./c/lib_cairo"
require "./c/xlib"

module Cairo
  include Cairo::C

  class Surface
    def initialize()

    end

    def to_unsafe : LibCairo::PSurfaceT
      @surface
    end
  end
end
