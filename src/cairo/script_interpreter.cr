require "./c/lib_cairo"
require "./c/script_interpreter"

module Cairo
  include Cairo::C

  # Wrapper for LibCairo::PScriptInterpreterT
  class ScriptInterpreter
    def initialize(script_interpreter : LibCairo::PScriptInterpreterT)
      raise ArgumentError.new("'script_interpreter' cannot be null.") unless script_interpreter.null?
      @script_interpreter = script_interpreter
    end

    def initialize
      @script_interpreter = LibCairo.script_interpreter_create
    end

    def finalize
      LibCairo.script_interpreter_destroy(@script_interpreter)
    end

    def install_hooks(hooks : ScriptInterpreterHooksT)
      LibCairo.script_interpreter_install_hooks(@script_interpreter, pointerof(hooks))
    end

    def run(filename : String) : Status
      Status.new(LibCairo.script_interpreter_run(@script_interpreter, filename.to_unsafe).value)
    end

    def feed_stream(stream : Int32) : Status
      Status.new(LibCairo.script_interpreter_feed_stream(@script_interpreter, stream).value)
    end

    def feed_string(line : String, len : Int32 = -1) : Status
      Status.new(LibCairo.script_interpreter_feed_string(@script_interpreter, line_to_unsafe, len).value)
    end

    def line_number : UInt32
      LibCairo.script_interpreter_get_line_number
    end

    def reference : ScriptInterpreter
      ScriptInterpreter.new(script_interpreter_reference(@script_interpreter))
    end

    def finish : Status
      Status.new(LibCairo.script_interpreter_finish(@script_interpreter).value)
    end

    def self.translate_stream(stream : Int32, write_func : LibCairo::WriteFuncT, closure : Void*) : Status
      Status.new(LibCairo.script_interpreter_translate_stream(stream, write_func, closure).value)
    end
  end
end
