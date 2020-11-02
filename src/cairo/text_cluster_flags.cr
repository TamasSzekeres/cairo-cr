module Cairo
  # Specifies properties of a text cluster mapping.
  enum TextClusterFlags
    # The clusters in the cluster array map to glyphs in the glyph array from end to start.
    Backward = 0x00000001
  end
end
