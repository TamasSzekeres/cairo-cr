require "./c/lib_cairo"

module Cairo
  include Cairo::C

  enum Status
    Success = 0,

    NoMemory,
    InvalidRestore,
    InvalidPopGroup,
    NoCurrentPoint,
    InvalidMatrix,
    InvalidStatus,
    NullPointer,
    InvalidString,
    InvalidPathData,
    ReadError,
    WriteError,
    SurfaceFinished,
    SurfaceTypeMismatch,
    PatternTypeMismatch,
    InvalidContent,
    InvalidFormat,
    InvalidVisual,
    FileNotFound,
    InvalidDash,
    InvalidDscComment,
    InvalidIndex,
    ClipNotRepresentable,
    TempFileRrror,
    InvalidStride,
    FontTypeMismatch,
    UserFontImmutable,
    UserFontError,
    NegativeCount,
    InvalidClusters,
    InvalidSlant,
    InvalidWeight,
    InvalidSize,
    UserFontNotImplemented,
    DeviceTypeMismatch,
    DeviceError,
    InvalidMeshConstruction,
    DeviceFinished,
    Jbig2GlobalMissing,

    LastStatus

    def to_string : String
      String.new(LibCairo.status_to_string(LibCairo::StatusT.new(self)))
    end
  end
end
