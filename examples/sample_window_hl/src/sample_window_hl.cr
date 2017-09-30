require "x11"
require "cairo"

module X11Sample
  include X11
  include Cairo

  WM_DELETE_WINDOW_STR = "WM_DELETE_WINDOW"

  def self.main
    d = Display.new
    wm_delete_window = d.intern_atom(WM_DELETE_WINDOW_STR, false)

    s = d.default_screen_number
    root_win = d.root_window s
    black_pix = d.black_pixel s
    white_pix = d.white_pixel s
    win = d.create_simple_window root_win, 10, 10, 400_u32, 300_u32, 1_u32, black_pix, white_pix
    d.select_input win,
      ButtonPressMask | ButtonReleaseMask |
      ButtonMotionMask | ExposureMask | EnterWindowMask |
      LeaveWindowMask | KeyPressMask | KeyReleaseMask
    d.map_window win
    d.set_wm_protocols win, [wm_delete_window]

    # Set Window Title.
    d.store_name win, "Simple Window"

    sfc = Cairo::XlibSurface.new d, win, d.default_visual(s), 400, 300
    ctx = Cairo::Context.new sfc

    while true
      if d.pending
        e = d.next_event
        case e
        when ExposeEvent
          ctx.set_source_rgba 1.0, 0.0, 1.0, 1.0
          ctx.rectangle 0.0, 0.0, 400.0, 300.0
          ctx.fill

          ctx.set_source_rgb 0.0, 0.0, 0.0
          ctx.move_to 0.0, 0.0
          ctx.line_to 400.0, 300.0
          ctx.move_to 400.0, 0.0
          ctx.line_to 0.0, 300.0
          ctx.line_width = 10.0
          ctx.stroke

          ctx.rectangle 0.0, 0.0, 200.0, 150.0
          ctx.set_source_rgba 1.0, 0.0, 0.0, 0.80
          ctx.fill

          ctx.rectangle 0.0, 150.0, 200.0, 150.0
          ctx.set_source_rgba 0.0, 1.0, 0.0, 0.60
          ctx.fill

          ctx.rectangle 200.0, 0.0, 200.0, 150.0
          ctx.set_source_rgba 0.0, 0.0, 1.0, 0.40
          ctx.fill
        when ClientMessageEvent
          break if e.long_data[0] == wm_delete_window
        when KeyEvent
          break if e.press?
       end
     end
    end

    d.destroy_window win
    d.close
    0
  end

  main
end
