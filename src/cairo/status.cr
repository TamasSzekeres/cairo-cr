require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # Cairo uses a single status type to represent all kinds of errors. A status value of `Success` represents no error and has an integer
  # value of zero. All other status values represent an error.
  #
  # Cairo's error handling is designed to be easy to use and safe. All major cairo objects retain an error status internally
  # which can be queried anytime by the users using `status` calls. In the mean time,
  # it is safe to call all cairo functions normally even if the underlying object is in an error status.
  # This means that no error handling code is required before or after each individual cairo function call.
  #
  #
  # `Status` is used to indicate errors that can occur when using `Context`. In some cases it is returned directly by functions.
  # But when using `Context`, the last error, if any, is stored in the context and can be retrieved with `Context#status`.
  #
  # New entries may be added in future versions. Use `Status#to_string` to get a human-readable representation of an error message.
  enum Status
    # No error has occurred.
    Success = 0

    # Out of memory.
    NoMemory

    # `Context#restore` called without matching `Context#save`.
    InvalidRestore

    # No saved group to pop, i.e. `Context#pop_group` without matching `Context#push_group`.
    InvalidPopGroup

    # No current point defined.
    NoCurrentPoint

    # Invalid matrix (not invertible).
    InvalidMatrix

    # Invalid value for an input `Status`.
    InvalidStatus

    # NULL pointer.
    NullPointer

    # Input string not valid UTF-8.
    InvalidString

    # Input path data not valid.
    InvalidPathData

    # Error while reading from input stream.
    ReadError

    # Error while writing to output stream.
    WriteError

    # Target surface has been finished.
    SurfaceFinished

    # The surface type is not appropriate for the operation.
    SurfaceTypeMismatch

    # The pattern type is not appropriate for the operation.
    PatternTypeMismatch

    # Invalid value for an input `Content`.
    InvalidContent

    # Invalid value for an input `Format`.
    InvalidFormat

    # Invalid value for an input `Visual`.
    InvalidVisual

    # File not found.
    FileNotFound

    # Invalid value for a dash setting.
    InvalidDash

    # Invalid value for a DSC comment.
    InvalidDscComment

    # Invalid index passed to getter.
    InvalidIndex

    # Clip region not representable in desired format.
    ClipNotRepresentable

    # Error creating or writing to a temporary file.
    TempFileRrror

    # Invalid value for stride.
    InvalidStride

    # The font type is not appropriate for the operation.
    FontTypeMismatch

    # The user-font is immutable.
    UserFontImmutable

    # Error occurred in a user-font callback function.
    UserFontError

    # Negative number used where it is not allowed.
    NegativeCount

    # Input clusters do not represent the accompanying text and glyph array.
    InvalidClusters

    # Invalid value for an input `FontSlant`.
    InvalidSlant

    # Invalid value for an input `FontWeight`.
    InvalidWeight

    # Invalid value (typically too big) for the size of the input (surface, pattern, etc.).
    InvalidSize

    # User-font method not implemented.
    UserFontNotImplemented

    # The device type is not appropriate for the operation.
    DeviceTypeMismatch

    # An operation to the device caused an unspecified error.
    DeviceError

    # A mesh pattern construction operation was used outside of a
    # `Pattern#begin_patch`/`Pattern#end_patch` pair.
    InvalidMeshConstruction

    # Target device has been finished.
    DeviceFinished

    # `Cairo::C::LibCairo::MIME_TYPE_JBIG2_GLOBAL_ID` has been used on at least one image but no image provided `Cairo::C::LibCairo::MIME_TYPE_JBIG2_GLOBAL`.
    Jbig2GlobalMissing

    # Error occurred in libpng while reading from or writing to a PNG file.
    PNG_ERROR

    # Error occurred in libfreetype.
    FREETYPE_ERROR

    # Error occurred in the Windows Graphics Device Interface.
    WIN32_GDI_ERROR

    # Invalid tag name, attributes, or nesting.
    TAG_ERROR

    # This is a special value indicating the number of status values defined in this enumeration.
    # When using this value, note that the version of cairo at run-time may have additional status values defined
    # than the value of this symbol at compile-time.
    LastStatus

    # Provides a human-readable description.
    def to_string : String
      String.new(LibCairo.status_to_string(LibCairo::StatusT.new(self)))
    end
  end
end
