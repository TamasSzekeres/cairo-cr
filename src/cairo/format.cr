require "./c/lib_cairo"

module Cairo
  include Cairo::C

  enum Format
    Invalid   = -1,
    ARGB32    = 0,
    RGB24     = 1,
    A8        = 2,
    A1        = 3,
    RGB16_565 = 4,
    RGB30     = 5

    def stride_for_width(width : Int32) : Int32
      LibCairo.format_stride_for_width(LibCairo::FormatT.new(self.value), width)
    end
  end
end
