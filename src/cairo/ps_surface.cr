require "./c/features"
require "./c/lib_cairo"
require "./c/ps"

{% if Cairo::C::HAS_PS_SURFACE %}

module Cairo
  include Cairo::C

  # The PostScript surface is used to render cairo graphics to Adobe PostScript
  # files and is a multi-page vector surface backend.
  #
  # The following mime types are supported:
  # - `Cairo::C::LibCairo::MIME_TYPE_JPEG`,
  # - `Cairo::C::LibCairo::MIME_TYPE_UNIQUE_ID`,
  # - `Cairo::C::LibCairo::MIME_TYPE_CCITT_FAX`,
  # - `Cairo::C::LibCairo::MIME_TYPE_CCITT_FAX_PARAMS`,
  # - `Cairo::C::LibCairo::MIME_TYPE_CCITT_FAX`,
  # - `Cairo::C::LibCairo::MIME_TYPE_CCITT_FAX_PARAMS`,
  # - `Cairo::C::LibCairo::MIME_TYPE_EPS`,
  # - `Cairo::C::LibCairo::MIME_TYPE_EPS_PARAMS`.
  #
  # Source surfaces used by the PostScript surface that have a
  # `Cairo::C::LibCairo::MIME_TYPE_UNIQUE_ID` mime type will be stored in
  # PostScript printer memory for the duration of the print job.
  # `Cairo::C::LibCairo::MIME_TYPE_UNIQUE_ID` should only be used for small
  # frequently used sources.
  #
  # The `Cairo::C::LibCairo::MIME_TYPE_CCITT_FAX` and
  # `Cairo::C::LibCairo::MIME_TYPE_CCITT_FAX_PARAMS` mime types are documented in
  # [CCITT Fax Images](https://cairographics.org/manual/cairo-PDF-Surfaces.html#ccitt).
  #
  # ##Embedding EPS files
  # Encapsulated PostScript files can be embedded in the PS output by setting the
  # `Cairo::C::LibCairo::MIME_TYPE_EPS` mime data on a surface to the EPS data
  # and painting the surface. The EPS will be scaled and translated to the
  # extents of the surface the EPS data is attached to.
  #
  # The `Cairo::C::LibCairo::MIME_TYPE_EPS` mime type requires the
  # `Cairo::C::LibCairo::MIME_TYPE_EPS_PARAMS` mime data to also be provided
  # in order to specify the embeddding parameters.
  # `Cairo::C::LibCairo::MIME_TYPE_EPS_PARAMS` mime data must contain a string
  # of the form `"bbox=[llx lly urx ury]"` that specifies the bounding box
  # (in PS coordinates) of the EPS graphics. The parameters are: lower left x,
  # lower left y, upper right x, upper right y. Normally the bbox data is
  # identical to the `%%BoundingBox` data in the EPS file.
  class PsSurface < Surface
    # Creates a PostScript surface of the specified size in points to be written
    # to filename.
    #
    # NOTE: that the size of individual pages of the PostScript output can vary.
    # See `PsSurface#set_size`.
    #
    # ###Parameters
    # - **filename** a filename for the PS output (must be writable),
    # `nil` may be used to specify no output. This will generate a PS surface
    # that may be queried and used as a source, without generating a temporary file.
    # - **width_in_points**  width of the surface, in points (1 point == 1/72.0 inch)
    # - **height_in_points** height of the surface, in points (1 point == 1/72.0 inch)
    #
    # ###Returns
    # A pointer to the newly created surface. The caller owns the surface and
    # should call `Surface#finalize` when done with it.
    #
    # This function always returns a valid pointer, but it will return a
    # pointer to a "nil" surface if an error such as out of memory occurs.
    # You can use `Surface#status` to check for this.
    def initialize(filename : String, width_in_points : Float64, height_in_points : Float64)
      super(LibCairo.ps_surface_create(filename.to_unsafe, width_in_points, height_in_points))
    end

    # Creates a PostScript surface of the specified size in points to be
    # written incrementally to the stream represented by *write_func* and
    # closure. See `PsSurface#initialize` for a more convenient way to
    # simply direct the PostScript output to a named file.
    #
    # NOTE: that the size of individual pages of the PostScript output can vary.
    # See `PsSurface#set_size`.
    #
    # ###Parameters
    # - **write_func** a `Cairo::C::LibCairo::WriteFuncT` to accept the output
    # data, may be `nil` to indicate a no-op *write_func*.
    # With a no-op *write_func*, the surface may be queried or used as a
    # source without generating any temporary files.
    # - **closure** the closure argument for *write_func*
    # - **width_in_points** width of the surface, in points (1 point == 1/72.0 inch)
    # - **height_in_points** height of the surface, in points (1 point == 1/72.0 inch)
    #
    # ###Returns
    # A pointer to the newly created surface. The caller owns the surface and
    # should call `Surface#finalize` when done with it.
    #
    # This function always returns a valid pointer, but it will return a pointer
    # to a "nil" surface if an error such as out of memory occurs.
    # You can use `Surface#status` to check for this.
    def initialize(write_func : LibCairo::WriteFuncT, closure : Void*, width_in_points : Float64, height_in_points : Float64)
      super(LibCairo.ps_surface_create_for_stream(write_func, closure, width_in_points, height_in_points))
    end

    # Restricts the generated PostSript file to level.
    # See `PsSurface#levels` for a list of available level values that can be used here.
    #
    # This function should only be called before any drawing operations have
    # been performed on the given surface. The simplest way to do this is to
    # call this function immediately after creating the surface.
    #
    # ###Parameters
    # - **level** PostScript level
    def restrict_to_level(level : PsLevel)
      LibCairo.ps_surface_restrict_to_level(to_unsafe, LibCairo::PsLevelT.new(level.value))
      self
    end

    # Used to retrieve the list of supported levels.
    # See `PsSurface#restrict_to_level`.
    #
    # ###Returns
    # Supported level list.
    def self.levels : Array(PsLevel)
      LibCairo.ps_get_levels(out levels, out num_levels)
      return [] of PsLevel if num_levels == 0
      Array(PsLevel).new(num_levels) do |i|
        PsLevel.new(levels[i].value)
      end
    end

    # Check whether the PostScript surface will output Encapsulated PostScript.
    #
    # ###Returns
    # `true` if the surface will output Encapsulated PostScript.
    def eps : Bool
      LibCairo.ps_surface_get_eps(to_unsafe) == 1
    end

    # If eps is `true`, the PostScript surface will output Encapsulated PostScript.
    #
    # This function should only be called before any drawing operations have been
    # performed on the current page. The simplest way to do this is to call this
    # function immediately after creating the surface. An Encapsulated PostScript
    # file should never contain more than one page.
    #
    # ###Parameters
    # - **eps** `true` to output EPS format PostScript.
    def eps=(eps : Bool)
      LibCairo.ps_surface_set_eps(to_unsafe, eps ? 1 : 0)
      self
    end

    # Changes the size of a PostScript surface for the current (and subsequent) pages.
    #
    # This function should only be called before any drawing operations have been
    # performed on the current page. The simplest way to do this is to call this
    # function immediately after creating the surface or immediately after
    # completing a page with either `Context#show_page` or `Context#copy_page`.
    #
    # ###Parameters
    # - **width_in_points** new surface width, in points (1 point == 1/72.0 inch)
    # - **height_in_points** new surface height, in points (1 point == 1/72.0 inch)
    def set_size(width_in_points : Float64, height_in_points : Float64)
      LibCairo.ps_surface_set_size(to_unsafe, width_in_points, height_in_points)
      self
    end

    # Emit a comment into the PostScript output for the given surface.
    #
    # The comment is expected to conform to the PostScript Language Document
    # Structuring Conventions (DSC). Please see that manual for details on
    # the available comments and their meanings. In particular,
    # the `%%IncludeFeature` comment allows a device-independent means of
    # controlling printer device features. So the PostScript Printer
    # Description Files Specification will also be a useful reference.
    #
    # The comment string must begin with a percent character (%) and the total
    # length of the string (including any initial percent characters) must not
    # exceed 255 characters. Violating either of these conditions will place
    # *surface* into an error state. But beyond these two conditions, this
    # function will not enforce conformance of the comment with any particular specification.
    #
    # The comment string should not have a trailing newline.
    #
    # The DSC specifies different sections in which particular comments can
    # appear. This function provides for comments to be emitted within three
    # sections: the header, the Setup section, and the PageSetup section.
    # Comments appearing in the first two sections apply to the entire document
    # while comments in the BeginPageSetup section apply only to a single page.
    #
    # For comments to appear in the header section, this function should be
    # called after the surface is created, but before a call to
    #`PsSurface#dsc_begin_setup`.
    #
    # For comments to appear in the Setup section, this function should be
    # called after a call to `PsSurface#dsc_begin_setup` but before a call
    # to `PsSurface#dsc_begin_page_setup`.
    #
    # For comments to appear in the PageSetup section, this function should
    # be called after a call to `PsSurface#dsc_begin_page_setup`.
    #
    # NOTE: that it is only necessary to call `PsSurface#dsc_begin_page_setup`
    # for the first page of any surface. After a call to `Context#show_page` or
    # `Context#copy_page` comments are unambiguously directed to the PageSetup
    # section of the current page. But it doesn't hurt to call this function at
    # the beginning of every page as that consistency may make the calling code simpler.
    #
    # As a final note, cairo automatically generates several comments on its own.
    # As such, applications must not manually generate any of the following comments:
    #
    # Header section: `%!PS-Adobe-3.0`, `%%Creator`, `%%CreationDate`, `%%Pages`,
    # `%%BoundingBox`, `%%DocumentData`, `%%LanguageLevel`, `%%EndComments`.
    #
    # Setup section: `%%BeginSetup`, `%%EndSetup`
    #
    # PageSetup section: `%%BeginPageSetup`, `%%PageBoundingBox`, `%%EndPageSetup`.
    #
    # Other sections: `%%BeginProlog`, `%%EndProlog`, `%%Page`, `%%Trailer`, `%%EOF`
    #
    # Here is an example sequence showing how this function might be used:
    def dsc_comment(comment : String)
      LibCairo.ps_surface_dsc_comment(to_unsafe, comment.to_unsafe)
      self
    end

    # This function indicates that subsequent calls to
    # `PsSurface#dsc_comment` should direct comments to
    # the Setup section of the PostScript output.
    #
    # This function should be called at most once per surface,
    # and must be called before any call to `PsSurface#dsc_begin_page_setup`
    # and before any drawing is performed to the surface.
    #
    # See `PsSurface#dsc_comment` for more details.
    def dsc_begin_setup
      LibCairo.ps_surface_dsc_begin_setup(to_unsafe)
      self
    end

    # This function indicates that subsequent calls to
    # `PsSurface#dsc_comment` should direct comments to the
    # PageSetup section of the PostScript output.
    #
    # This function call is only needed for the first page of a surface.
    # It should be called after any call to `PsSurface#dsc_begin_setup`
    # and before any drawing is performed to the surface.
    #
    # See `PsSurface#dsc_comment` for more details.
    def dsc_begin_page_setup
      LibCairo.ps_surface_dsc_begin_page_setup(to_unsafe)
      self
    end
  end
end

{% end %}
