require "./cairo"

module CairoCr
  @[Link("cairo")]
  lib Cairo
    alias PScriptInterpreterT = ScriptInterpreterT*
    alias ScriptInterpreterT = Void*

    # closure, ptr -> void
    alias CsiDestroyFuncT = Void*, Void* -> Void

    # closure, content, width, height, uid -> surface
    alias CsiSurfaceCreateFuncT = Void*, ContentT, Float64, Float64, Int64 -> PSurfaceT

    # closure, surface -> cairo
    alias CsiContextCreateFuncT = Void*, PSurfaceT -> PCairoT

    # closure, cr -> void
    alias CsiShowPageFuncT = Void*, PCairoT -> Void

    # closure, cr -> void
    alias CsiCopyPageFuncT = Void*, PCairoT -> Void

    # closure, format, width, height, uid -> surface
    alias CsiCreateSourceImageT = Void*, FormatT, Int32, Int32, Int64 -> PSurfaceT

    alias PScriptInterpreterHooksT = ScriptInterpreterHooksT*
    struct ScriptInterpreterHooksT
      closure : Void*
      surface_create : CsiSurfaceCreateFuncT
      surface_destroy : CsiDestroyFuncT
      context_create : CsiContextCreateFuncT
      context_destroy : CsiDestroyFuncT
      show_page : CsiShowPageFuncT
      copy_page : CsiShowPageFuncT
      create_source_image : CsiCreateSourceImageT
    end

    fun script_interpreter_create = cairo_script_interpreter_create(
    ) : PScriptInterpreterT

    fun script_interpreter_install_hooks = cairo_script_interpreter_install_hooks(
      ctx : PScriptInterpreterT,
      hooks : PScriptInterpreterHooksT
    ) : Void

    fun script_interpreter_run = cairo_script_interpreter_run(
      ctx : PScriptInterpreterT,
      filename : UInt8*
    ) : StatusT

    fun script_interpreter_feed_stream = cairo_script_interpreter_feed_stream(
      ctx : PScriptInterpreterT,
      stream : Int32
    ) : StatusT

    fun script_interpreter_feed_string = cairo_script_interpreter_feed_string(
      ctx : PScriptInterpreterT,
      line : UInt8*,
      len : Int32
    ) : StatusT

    fun script_interpreter_get_line_number = cairo_script_interpreter_get_line_number(
      ctx : PScriptInterpreterT
    ) : UInt32

    fun script_interpreter_reference = cairo_script_interpreter_reference(
      ctx : PScriptInterpreterT
    ) : PScriptInterpreterT

    fun script_interpreter_finish = cairo_script_interpreter_finish(
      ctx : PScriptInterpreterT
    ) : StatusT

    fun script_interpreter_destroy = cairo_script_interpreter_destroy(
      ctx : PScriptInterpreterT
    ) : StatusT

    fun script_interpreter_translate_stream = cairo_script_interpreter_translate_stream(
      stream : Int32,
      write_func : WriteFuncT,
      closure : Void*
    ) : StatusT
  end # lib Cairo
end # module CairoCr
