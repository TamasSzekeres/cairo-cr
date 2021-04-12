require "./c/lib_cairo"

module Cairo
  include Cairo::C

  # `UserDataKey` is used for attaching user data to cairo data structures.
  # The actual contents of the struct is never used, and there is no need
  # to initialize the object; only the unique address of a `UserDataKey` object
  # is used. Typically, you would just use the address of a static `UserDataKey` object.
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

    # Not used.
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
