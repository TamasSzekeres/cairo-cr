module Cairo
  # Used by the `PdfSurface#set_metadata` function specify the metadata to set.
  enum PdfMetadata
    # The document title.
    Title

    # The document author.
    Author

    # The document subject.
    Subject

    # The document keywords.
    Keywords

    # The document creator.
    Creator

    # The document creation date.
    CreateDate

    # The document modification date.
    ModDate
  end
end
