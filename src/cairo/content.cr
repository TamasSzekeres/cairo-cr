module Cairo
  # `Content` is used to describe the content that a surface will contain,
  # whether color information, alpha information (translucence vs. opacity), or both.
  #
  # NOTE: The large values here are designed to keep `content` values distinct
  # from `Format` values so that the implementation can detect the error if users confuse the two types.
  enum Content
    # The surface will hold color content only.
    Color      = 0x1000

    # The surface will hold alpha content only.
    Alpha      = 0x2000

    # The surface will hold color and alpha content.
    ColorAlpha = 0x3000
  end
end
