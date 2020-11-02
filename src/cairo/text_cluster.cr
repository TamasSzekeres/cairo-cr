require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # Wrapper for LibCairo::TextClusterT.
  #
  # The `TextCluster` class holds information about a single *text cluster*.
  # A text cluster is a minimal mapping of some glyphs corresponding to some UTF-8 text.
  #
  # For a cluster to be valid, both *num_bytes* and *num_glyphs* should be non-negative,
  # and at least one should be non-zero. Note that clusters with zero glyphs are not as
  # well supported as normal clusters. For example, PDF rendering applications typically
  # ignore those clusters when PDF text is being selected.
  #
  # See `Context#show_text_glyphs` for how clusters are used in advanced text operations.
  class TextCluster
    def initialize
      @text_cluster = LibCairo.text_cluster_allocate(1)
    end

    def initialize(text_cluster : LibCairo::PTextClusterT)
      raise ArgumentError.new("'text_cluster' cannot be null.") if text_cluster.null?
      @text_cluster = text_cluster
    end

    def finalize
      LibCairo.text_cluster_free(@text_cluster)
    end

    def to_unsafe : LibCairo::PTextClusterT
      @text_cluster
    end
  end
end
