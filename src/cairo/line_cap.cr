module Cairo
  # Specifies how to render the endpoints of the path when stroking.
  #
  # The default line cap style is `LineCap::Butt`.
  enum LineCap
    # Start(stop) the line exactly at the start(end) point.
    Butt

    # Use a round ending, the center of the circle is the end.
    Round

    # Use squared ending, the center of the square is the end.
    Square
  end
end
