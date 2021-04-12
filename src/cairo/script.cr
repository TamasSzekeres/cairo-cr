require "./c/lib_cairo"
require "./c/features"
require "./c/script"

{% if Cairo::C::HAS_SCRIPT_SURFACE %}

module Cairo
  include Cairo::C

  # The script surface provides the ability to render to a native script
  # that matches the cairo drawing model. The scripts can be replayed using
  # tools under the util/cairo-script directory, or with cairo-perf-trace.
  class Script < Device
    # Creates a output device for emitting the script,
    # used when creating the individual surfaces.
    #
    # ###Parameters
    # - **filename** the name (path) of the file to write the script to
    #
    # ###Returns
    # The newly created Script-Surface. The caller owns the surface
    # and should call `Script#finalize` when done with it.
    #
    # This function always returns a valid pointer,
    # but it will return a pointer to a `nil` device if an error such
    # as out of memory occurs. You can use `Context#status` to check for this.
    def initialize(filename : String)
      super(LibCairo.script_create(filename.to_unsafe))
    end

    # Creates a output device for emitting the script,
    # used when creating the individual surfaces.
    #
    # ###Parameters
    # - **write_func** callback function passed the bytes written to the script
    # - **closure** user data to be passed to the callback
    #
    # ###Returns
    # The newly created device. The caller owns the surface and
    # should call `Script#finalze` when done with it.
    #
    # This function always returns a valid pointer,
    # but it will return a pointer to a `nil` device if an error such
    # as out of memory occurs. You can use `Context#status` to check for this.
    def initialize(write_func : LibCairo::WriteFuncT, closure : Void*)
      super(LibCairo.script_create_for_stream(write_func, closure))
    end

    # Emit a string verbatim into the script.
    #
    # ###Parameters
    # - **comment** the string to emit
    # - **len** the length of the sting to write, or -1 to use `comment.size`
    def write_comment(comment : String, len : Int32 = -1)
      LibCairo.script_write_comment(to_unsafe, comment.to_unsafe, len)
      self
    end

    # Queries the script for its current output mode.
    #
    # ###Returns
    # The current output mode of the script.
    def mode : ScriptMode
      ScriptMode.new(LibCairo.script_get_mode(to_unsafe).value)
    end

    # Change the output mode of the script.
    #
    # ###Parameters
    # - **mode** the new mode
    def mode=(mode : ScriptMode)
      LibCairo.script_set_mode(to_unsafe, LibCairo::ScriptModeT.new(mode.value))
      self
    end

    # Create a new surface that will emit its rendering through script.
    #
    # ###Parameters
    # - **content** the content of the surface
    # - **width** width in pixels
    # - **height** height in pixels
    #
    # ###Returns
    # A pointer to the newly created `Surface`. The caller owns the surface and
    # should call `Surface#finalize` when done with it.
    #
    # This function always returns a valid pointer, but it will return a pointer
    # to a `nil` surface if an error such as out of memory occurs.
    # You can use `Surface#status` to check for this.
    def create_script_surface(content : Content, width : Float64, height : Float64) : Surface
      Surface.new(LibCairo.script_surface_create(to_unsafe, LibCairo::ContentT.new(content.value), width, height))
    end

    # Create a pxoy surface that will render to *target* and record the operations to *device*.
    #
    # ###Parameters
    # - **target** a target surface to wrap
    #
    # ###Returns
    # A pointer to the newly created `Surface`. The caller owns the surface and
    # should call `Surface#finalize` when done with it.
    #
    # This function always returns a valid pointer, but it will return a pointer
    # to a `nil` surface if an error such as out of memory occurs.
    # You can use `Surface#status` to check for this.
    def create_script_surface_for_target(target : Surface) : Surface
      Surface.new(LibCairo.script_surface_create_for_target(to_unsafe, target.to_unsafe))
    end

    # Converts the record operations in *recording_surface* into a script.
    #
    # ###Parameters
    # - **script** the script (output device)
    # - **recording_surface** the recording surface to replay
    #
    # ###Returns
    # `Status::Success` on successful completion or an error code.
    def from_recording_surface(recording_surface : Surface) : Status
      Status.new(LibCairo.script_from_recording_surface(to_unsafe, recording_surface.to_unsafe).value)
    end
  end
end

{% end %}
