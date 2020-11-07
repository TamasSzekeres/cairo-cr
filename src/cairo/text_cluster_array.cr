require "./c/lib_cairo"
require "./text_cluster"

module Cairo
  include Cairo::C

  class TextClusterArray
    include Indexable(TextCluster)

    def initialize(num_clusters : Int)
      @clusters = LibCairo.text_cluster_allocate(num_clusters)
      raise "Can't allocate clusters." if @clusters.null?
      @num_clusters = num_clusters
    end

    def initialize(clusters : LibCairo::PTextClusterT, num_clusters : Int32)
      raise ArgumentError.new("'clusters' cannot be null.") if clusters.null?
      raise ArgumentError.new("'num_clusters' must be positive.") unless num_clusters > 0

      @clusters = clusters
      @num_clusters = num_clusters
    end

    def finalize
      LibCairo.text_cluster_free(@clusters)
      @num_clusters = 0
    end

    # :inherit:
    def size
      @num_clusters
    end

    # :inherit:
    def unsafe_fetch(index : Int)
      (@clusters + index).value
    end

    def []=(index : Int, cluster : TextCluster)
      check_index_out_of_bounds index
      (@clusters + index).value = cluster.to_unsafe.value
    end

    def to_unsafe : LibCairo::PTextClusterT
      @clusters
    end
  end
end
