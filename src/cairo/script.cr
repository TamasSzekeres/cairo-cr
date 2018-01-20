require "./c/lib_cairo"
require "./c/features"
require "./c/script"

{% if Cairo::C::HAS_SCRIPT_SURFACE %}

module Cairo
  include Cairo::C

  class Script < Device
    def initialize(filename : String)
      super(LibCairo.script_create(filename.to_unsafe))
    end

    # Create for Stream
    def initialize(write_func : LibCairo::WriteFuncT, closure : Void*)
      super(LibCairo.script_create_for_stream(write_func, closure))
    end

    def write_comment(comment : String, len : Int32 = -1)
      LibCairo.script_write_comment(to_unsafe, comment.to_unsafe, len)
      self
    end

    def mode : ScriptMode
      ScriptMode.new(LibCairo.script_get_mode(to_unsafe).value)
    end

    def mode=(mode : ScriptMode)
      LibCairo.script_set_mode(to_unsafe, LibCairo::ScriptModeT.new(mode.value))
      self
    end

    def create_script_surface(content : Content, width : Float64, height : Float64) : Surface
      Surface.new(LibCairo.script_surface_create(to_unsafe, LibCairo::ContentT.new(content.value), width, height))
    end

    def create_script_surface_for_target(target : Surface) : Surface
      Surface.new(LibCairo.script_surface_create_for_target(to_unsafe, target.to_unsafe))
    end

    def from_recording_surface(recording_surface : Surface) : Status
      Status.new(LibCairo.script_from_recording_surface(to_unsafe, recording_surface.to_unsafe).value)
    end
  end
end

{% end %}
