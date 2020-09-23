require "./c/features"
require "./c/lib_cairo"
require "./c/pdf"

{% if Cairo::C::HAS_PDF_SURFACE %}

module Cairo
  enum PdfVersion
    V_1_4
    V_1_5

    def to_string : String
      String.new(LibCairo.pdf_version_to_string(LibCairo::PdfVersionT.new(self)))
    end
  end
end

{% end %}
