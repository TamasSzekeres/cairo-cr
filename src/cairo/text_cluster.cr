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
  struct TextCluster
    def initialize
      @cluster = uninitialized LibCairo::TextClusterT
      @cluster.num_bytes = 0
      @cluster.num_glyphs = 0
    end

    def initialize(num_bytes : Int32, num_glyphs : Int32)
      @cluster = uninitialized LibCairo::TextClusterT
      @cluster.num_bytes = num_bytes
      @cluster.num_glyphs = num_glyphs
    end

    def initialize(@cluster : LibCairo::TextClusterT)
    end

    def initialize(cluster : LibCairo::PTextClusterT)
      raise ArgumentError.new("'cluster' cannot be null.") if cluster.null?
      @cluster = cluster.value
    end

    # The number of bytes of UTF-8 text covered by cluster.
    def num_bytes : Int32
      @cluster.num_bytes
    end

    def num_bytes=(num_bytes : Int32)
      @cluster.num_bytes = num_bytes
    end

    # The number of glyphs covered by cluster.
    def num_glyphs : Int32
      @cluster.num_glyphs
    end

    def num_glyphs=(num_glyphs : Int32)
      @cluster.num_glyphs = num_glyphs
    end

    def to_cairo_cluster : LibCairo::TextClusterT
      @cluster
    end

    def to_unsafe : LibCairo::PTextClusterT
      pointerof(@cluster)
    end
  end
end
