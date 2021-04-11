require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # `Format` is used to identify the memory format of image data.
  enum Format
    # No such format exists or is supported.
    Invalid = -1

    # Each pixel is a 32-bit quantity, with alpha in the upper 8 bits,
    # then red, then green, then blue. The 32-bit quantities are stored native-endian.
    # Pre-multiplied alpha is used. (That is, 50% transparent red is 0x80800000, not 0x80ff0000.)
    ARGB32 = 0

    # Each pixel is a 32-bit quantity, with the upper 8 bits unused.
    # Red, Green, and Blue are stored in the remaining 24 bits in that order.
    RGB24 = 1

    # Each pixel is a 8-bit quantity holding an alpha value. 
    A8 = 2

    # Each pixel is a 1-bit quantity holding an alpha value.
    # Pixels are packed together into 32-bit quantities.
    # The ordering of the bits matches the endianness of the platform.
    # On a big-endian machine, the first pixel is in the uppermost bit,
    # on a little-endian machine the first pixel is in the least-significant bit.
    A1 = 3

    # Each pixel is a 16-bit quantity with red in the upper 5 bits,
    # then green in the middle 6 bits, and blue in the lower 5 bits.
    RGB16_565 = 4

    # Like `Format::RGB24` but with 10bpc.
    RGB30 = 5

    # This function provides a stride value that will respect all alignment requirements of the accelerated
    # image-rendering code within cairo.
    #
    # ###Parameters
    # - **width** The desired width of an image surface to be created.
    #
    # ###Returns
    # The appropriate stride to use given the desired format and width,
    # or -1 if either the format is invalid or the width too large.
    def stride_for_width(width : Int32) : Int32
      LibCairo.format_stride_for_width(LibCairo::FormatT.new(self.value), width)
    end
  end
end
