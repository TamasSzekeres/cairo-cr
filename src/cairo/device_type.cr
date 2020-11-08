module Cairo
  # `DeviceType` is used to describe the type of a given device.
  # The devices types are also known as "backends" within cairo.
  #
  # The device type can be queried with `Device#type`.
  #
  # New entries may be added in future versions.
  enum DeviceType
    # The device is of type Direct Render Manager.
    DRM

    # The device is of type OpenGL.
    GL

    # The device is of type script.
    Script

    # The device is of type xcb.
    XCB

    # The device is of type xlib.
    XLib

    # The device is of type XML.
    XML

    # The device is of type cogl.
    COGL

    # The device is of type win32.
    Win32


    # The device is invalid.
    Invalid = -1
  end
end
