module Cairo
  # Specifies how to render the junction of two lines when stroking.
  #
  # The default line join style is `LineJoin::Miter`.
  enum LineJoin
    # Use a sharp (angled) corner, see `Context#miter_limit=(limit)`.
    Miter

    # Use a rounded join, the center of the circle is the joint point.
    Round

    # Use a cut-off join, the join is cut off at half the line width from the joint point.
    Bevel
  end
end
