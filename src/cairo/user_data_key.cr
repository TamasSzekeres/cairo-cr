require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # Wrapper for LibCairo::UserDataKeyT
  class UserDataKey
    def initialize
      @key = LibCairo::UserDataKeyT.new
    end

    def initialize(unused : Int32)
      @key = LibCairo::UserDataKeyT.new
      @key.unused = unused
    end

    def initialize(@key : LibCairo::UserDataKeyT)
    end

    def unused : Int32
      @key.unused
    end

    def unused=(unused : Int32)
      @key.unused = unused
    end

    # Returns the underlieing structure.
    def user_data_key : LibCairo::UserDataKeyT
      @key
    end

    # Returns the pointer of the underlieing structure.
    def to_unsafe : LibCairo::PUserDataKeyT
      pointerof(@key)
    end
  end
end
