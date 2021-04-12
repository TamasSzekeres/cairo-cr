require "./c/features"
require "./c/lib_cairo"
require "./c/pdf"

{% if Cairo::C::HAS_PDF_SURFACE %}

module Cairo
  # `PdfVersion` is used to describe the version number of the
  # PDF specification that a generated PDF file will conform to.
  enum PdfVersion
    # The version 1.4 of the PDF specification.
    V_1_4

    # The version 1.5 of the PDF specification.
    V_1_5

    # Get the string representation of the given version id.
    # This function will return `nil` if version isn't valid.
    # See `PdfSurface#versions` for a way to get the list of valid version ids.
    #
    # ###Returns
    # The string associated to given version.
    def to_string : String
      String.new(LibCairo.pdf_version_to_string(LibCairo::PdfVersionT.new(self)))
    end
  end
end

{% end %}
