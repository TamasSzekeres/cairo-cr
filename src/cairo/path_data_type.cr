module Cairo
  # Used to describe the type of one portion of a path when represented as a `Path`.
  # See `PathData` for details.
  enum PathDataType
    # A move-to operation.
    MoveTo

    # A line-to operation.
    LineTo

    # A curve-to operation.
    CurveTo

    # A close-path operation.
    ClosePath
  end
end
