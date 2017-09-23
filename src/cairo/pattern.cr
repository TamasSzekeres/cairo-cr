require "./c/lib_cairo"

module Cairo
  include Cairo::C

  class Pattern
    def initialize(pattern : LibCairo::PPatternT)
      raise ArgumentError.new("'pattern' cannot be null") if pattern.null?
      @pattern = pattern
    end

    def to_unsafe : LibCairo::PPatternT
      @pattern
    end
  end
end
