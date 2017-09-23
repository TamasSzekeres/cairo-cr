require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # Wrapper for LibCairo::TextClusterT.
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
