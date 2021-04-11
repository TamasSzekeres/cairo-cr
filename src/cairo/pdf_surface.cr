require "./c/features"
require "./c/lib_cairo"
require "./c/pdf"
require "./surface"

{% if Cairo::C::HAS_PDF_SURFACE %}

module Cairo
  include Cairo::C

  # The PDF surface is used to render cairo graphics to Adobe PDF files and is
  # a multi-page vector surface backend.
  #
  # The following mime types are supported:
  # - `Cairo::C::LibCairo::MIME_TYPE_JPEG`,
  # - `Cairo::C::LibCairo::MIME_TYPE_JP2`,
  # - `Cairo::C::LibCairo::MIME_TYPE_UNIQUE_ID`,
  # - `Cairo::C::LibCairo::MIME_TYPE_JBIG2`,
  # - `Cairo::C::LibCairo::MIME_TYPE_JBIG2_GLOBAL`,
  # - `Cairo::C::LibCairo::MIME_TYPE_JBIG2_GLOBAL_ID`,
  # - `Cairo::C::LibCairo::MIME_TYPE_CCITT_FAX`,
  # - `Cairo::C::LibCairo::MIME_TYPE_CCITT_FAX_PARAMS`.
  #
  # ###JBIG2 Images
  # JBIG2 data in PDF must be in the embedded format as described
  # in ISO/IEC 11544. Image specific JBIG2 data must be in
  # `Cairo::C::LibCairo::MIME_TYPE_JBIG2`. Any global segments in the JBIG2 data
  # (segments with page association field set to 0) must be in
  # `Cairo::C::LibCairo::MIME_TYPE_JBIG2_GLOBAL`. The global data may be shared
  # by multiple images. All images sharing the same global data must set
  # `Cairo::C::LibCairo::MIME_TYPE_JBIG2_GLOBAL_ID` to a unique identifier.
  # At least one of the images must provide the global data using
  # `Cairo::C::LibCairo::MIME_TYPE_JBIG2_GLOBAL`. The global data will only be
  # embedded once and shared by all JBIG2 images with the same
  # `Cairo::C::LibCairo::MIME_TYPE_JBIG2_GLOBAL_ID`.
  #
  # ###CCITT Fax Images
  # The `Cairo::C::LibCairo::MIME_TYPE_CCITT_FAX` mime data requires a number of
  # decoding parameters These parameters are specified
  # using `Cairo::C::LibCairo::MIME_TYPE_CCITT_FAX_PARAMS`.
  #
  # `Cairo::C::LibCairo::MIME_TYPE_CCITT_FAX_PARAMS` mime data must contain
  # a string of the form `"param1=value1 param2=value2 ..."`.
  #
  # *Columns*: [required] An integer specifying the width of the image in pixels.
  #
  # *Rows*: [required] An integer specifying the height of the image in scan lines.
  #
  # *K* : [optional] An integer identifying the encoding scheme used.
  # < 0 is 2 dimensional Group 4, = 0 is Group3 1 dimensional, > 0
  # is mixed 1 and 2 dimensional encoding. Default is 0.
  #
  # *EndOfLine* : [optional] If true end-of-line bit patterns are present.
  # Default is false.
  #
  # *EncodedByteAlign* : [optional] If true the end of line is padded with 0
  # bits so the next line begins on a byte boundary. Default is false.
  #
  # *EndOfBlock* : [optional] If true the data contains an end-of-block
  # pattern. Default is true.
  #
  # *BlackIs1* : [optional] If true 1 bits are black pixels. Default is false.
  #
  # *DamagedRowsBeforeError* : [optional] An integer specifying the number of
  # damages rows tolerated before an error occurs. Default is 0.
  #
  # Boolean values may be "true" or "false", or 1 or 0.
  #
  # These parameters are the same as the CCITTFaxDecode parameters in the
  # [PostScript Language Reference](https://www.adobe.com/products/postscript/pdfs/PLRM.pdf)
  # and [Portable Document Format (PDF)](https://www.adobe.com/content/dam/Adobe/en/devnet/pdf/pdfs/PDF32000_2008.pdf).
  # Refer to these documents for further details.
  #
  # An example `Cairo::C::LibCairo::MIME_TYPE_CCITT_FAX_PARAMS` string is:
  # `"Columns=10230 Rows=40000 K=1 EndOfLine=true EncodedByteAlign=1 BlackIs1=false"`
  class PdfSurface < Surface
    # Creates a PDF surface of the specified size in points to be written to
    # filename.
    #
    # ###Parameters
    # - **filename** a filename for the PDF output (must be writable), `nil`
    # may be used to specify no output. This will generate a PDF surface that
    # may be queried and used as a source, without generating a temporary file.
    # - **width_in_points** width of the surface,
    # in points (1 point == 1/72.0 inch)
    # - **height_in_points** height of the surface,
    # in points (1 point == 1/72.0 inch)
    #
    # ###Returns
    # A pointer to the newly created `Surface`. The caller owns the surface and
    # should call `Surface#finalize` when done with it.
    #
    # This function always returns a valid pointer, but it will return a
    # pointer to a "nil" surface if an error such as out of memory occurs.
    # You can use `Surface#status` to check for this.
    def initialize(filename : String, width_in_points : Float64, height_in_points : Float64)
      super(LibCairo.pdf_surface_create(filename.to_unsafe, width_in_points, height_in_points))
    end

    # Creates a PDF surface of the specified size in points to be written
    # incrementally to the stream represented by write_func and closure .
    #
    # ###Parameters
    # - **write_func** a `Cairo::C::LibCairo::WriteFuncT` to accept the output
    # data, may be `nil` to indicate a no-op *write_func*.
    # With a no-op *write_func*, the surface may be queried or used as a source
    # without generating any temporary files.
    # - **closure** the closure argument for *write_func*
    # - **width_in_points** width of the surface,
    # in points (1 point == 1/72.0 inch)
    # - **height_in_points** height of the surface,
    # in points (1 point == 1/72.0 inch)
    #
    # ###Returns
    # A pointer to the newly created `Surface`.
    # The caller owns the surface and should call `Surface#finalize` when done
    # with it.
    #
    # This function always returns a valid pointer, but it will return a
    # pointer to a "nil" surface if an error such as out of memory occurs.
    # You can use `Surface#status` to check for this.
    def initialize(write_func : LibCairo::WriteFuncT, closure : Void*, width_in_points : Float64, height_in_points : Float64)
      super(LibCairo.pdf_surface_create_for_stream(write_func, closure, width_in_points, height_in_points))
    end

    # Restricts the generated PDF file to version.
    # See `PdfSurface#versions` for a list of available version values
    # that can be used here.
    #
    # This function should only be called before any drawing operations have
    # been performed on the given surface. The simplest way to do this is to
    # call this function immediately after creating the surface.
    #
    # ###Parameters
    # - **version** PDF version
    def restrict_to_version(version : PdfVersion)
      LibCairo.pdf_surface_restrict_to_version(to_unsafe, LibCairo::PdfVersionT.new(version.value))
      self
    end

    # Used to retrieve the list of supported versions.
    # See `PdfSurface#restrict_to_version`.
    #
    # ###Returns
    # Supported version list.
    def self.versions : Array(PdfVersion)
      LibCairo.pdf_get_versions(out version, out num_versions)
      return [] of PdfVersion if num_versions == 0
      Array(PdfVersion).new(num_versions) do |i|
        PdfVersion.new(version[i].value)
      end
    end

    # Changes the size of a PDF surface for the current (and subsequent) pages.
    #
    # This function should only be called before any drawing operations have
    # been performed on the current page. The simplest way to do this is to
    # call this function immediately after creating the surface or immediately
    # after completing a page with either `Context#show_page`
    # or `Context#copy_page`.
    #
    # ###Parameters
    # - **width_in_points** new surface width, in points
    # (1 point == 1/72.0 inch)
    # - **height_in_points** new surface height,
    # in points (1 point == 1/72.0 inch)
    def set_size(width_in_points : Float64, height_in_points : Float64)
      LibCairo.pdf_surface_set_size(to_unsafe, width_in_points, height_in_points)
      self
    end

    # Add an item to the document outline hierarchy with the name that links
    # to the location specified by *link_attribs*. Link attributes have the
    # same keys and values as the *Link Tag*, excluding the "rect" attribute.
    # The item will be a child of the item with id *parent_id*.
    # Use `Cairo::C::LibCaio::PDF_OUTLINE_ROOT` as the parent id of top level items.
    #
    # ###Parameters
    # - **parent_id** the id of the parent item or
    # `Cairo::C::LibCairo::PDF_OUTLINE_ROOT` if this is a top level item.
    # - **name** the name of the outline
    # - **link_attribs** the link attributes specifying where this outline links to
    # - **flags** outline item flags
    #
    # ###Returns
    # The id for the added item.
    def add_outline(parent_id : Int32, name : String, link_attribs : String, flags : PdfOutlineFlags): Int
      LibCairo.pdf_surface_add_outline(to_unsafe, parent_id, name.to_unsafe, link_attribs.to_unsafe, LibCairo.PdfOutlineFlagsT.new(flags.value))
    end

    # Set document metadata. The `PdfMetadata::CreateDate`
    # and `PdfMetadata::ModDate` values must be in ISO-8601 format: YYYY-MM-DDThh:mm:ss.
    # An optional timezone of the form "[+/-]hh:mm" or "Z" for UTC time can be appended.
    # All other metadata values can be any UTF-8 string.
    #
    # For example:
    # ```
    # surface.set_metadata(PdfMetadata::MetadataTitle, "My Document")
    # surface.set_metadata(PdfMetadata::CreateDate, "2015-12-31T23:59+02:00")
    # ```
    #
    # ###Parameters
    # - **metadata** The metadata item to set.
    # - **value** metadata value
    def set_metadata(metadata : PdfMetadata, value : String)
      LibCairo.pdf_surface_set_metadata(to_unsafe, LibCairo.PdfMetadataT.new(metadata.value), value.to_unsafe)
      self
    end

    # Set page label for the current page.
    #
    # ###Parameters
    # - **label** The page label.
    def page_label=(label : String)
      LibCairo.pdf_surface_set_label(to_unsafe, label.to_unsafe)
      self
    end

    # Set the thumbnail image size for the current and all subsequent pages.
    # Setting a width or height of 0 disables thumbnails for the current and subsequent pages.
    #
    # ###Parameters
    # - **width** Thumbnail width.
    # - **height** Thumbnail height
    def set_thumbnail_size(width : Int32, height : Int32)
      LibCairo.pdf_surface_set_thumbnail_size(to_unsafe, width, height)
      self
    end
  end
end

{% end %}
