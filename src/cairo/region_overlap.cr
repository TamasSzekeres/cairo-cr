module Cairo
  # Used as the return value for `Region#contains_rectangle`.
  enum RegionOverlap
    # The contents are entirely inside the region.
    In

    # The contents are entirely outside the region.
    Out

    # The contents are partially inside and partially outside the region.
    Part
  end
end
