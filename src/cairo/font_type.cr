module Cairo
  # `FontType is used to describe the type of a given font face or scaled font.
  # The font types are also known as "font backends" within cairo.
  #
  # The type of a font face is determined by the function used to create it,
  # which will generally be of the form `FontFace#initialize`.
  # The font face type can be queried with `FontFace#type`.
  #
  # The various `FontFace` functions can be used with a font face of any type.
  #
  # The type of a scaled font is determined by the type of the font face passed to
  # `FontFace#create_scaled_font`. The scaled font type can be queried with `scaledFont#type`.
  #
  # The various `ScaledFont` functions can be used with scaled fonts of any type,
  # but some font backends also provide type-specific functions that must only be
  # called with a scaled font of the appropriate type.
  #
  # The behavior of calling a type-specific function with a scaled font of the wrong type is undefined.
  #
  # New entries may be added in future versions.
  enum FontType
    # The font was created using cairo's toy font api.
    Toy

    # The font is of type FreeType.
    Ft

    # The font is of type Win32.
    Win32

    # The font is of type Quartz
    Quartz

    # The font was create using cairo's user font api.
    User
  end
end
