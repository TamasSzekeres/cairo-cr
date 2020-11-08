module Cairo
  # Specifies whether to hint font metrics; hinting font metrics means quantizing
  # them so that they are integer values in device space. Doing this improves the
  # consistency of letter and line spacing,
  # however it also means that text will be laid out differently at different zoom factors.
  enum HintMetrics
    # Hint metrics in the default manner for the font backend and target device.
    Default

    # Do not hint font metrics.
    Off

    # Hint font metrics.
    On
  end
end
