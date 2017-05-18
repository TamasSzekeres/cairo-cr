require "x11"
require "../src/*"

module X11Sample
  include X11
  include CairoCr
  WM_DELETE_WINDOW_STR = "WM_DELETE_WINDOW"

  def self.main
    d = uninitialized X::PDisplay
    d = X.open_display(nil)
    wm_delete_window = X.intern_atom(d, WM_DELETE_WINDOW_STR, 0)

    if d.is_a?(Nil)
      return 1
    end

    s = X11.default_screen d
    root_win = X11.root_window d, s
    black_pix = X11.black_pixel d, s
    white_pix = X11.white_pixel d, s
    win = X.create_simple_window d, root_win, 10, 10, 400, 300, 1, black_pix, white_pix
    X.select_input d, win,
      ButtonPressMask | ButtonReleaseMask |
      ButtonMotionMask | ExposureMask | EnterWindowMask |
      LeaveWindowMask | KeyPressMask | KeyReleaseMask
    X.map_window d, win
    X.set_wm_protocols d, win, pointerof(wm_delete_window), 1

    # Set Window Title.
    X.store_name d, win, "Simple Window"

    sfc = Cairo.xlib_surface_create d, win, X11.default_visual(d, s), 400, 300
    ctx = Cairo.create sfc

    e = uninitialized X::Event
    while true
      if X.pending d
        X.next_event(d, pointerof(e))
        case e.type
        when Expose
          Cairo.set_source_rgba ctx, 1, 1, 1, 1
          Cairo.rectangle ctx, 0, 0, 400, 300
          Cairo.fill ctx

          Cairo.set_source_rgb ctx, 0, 0, 0
          Cairo.move_to ctx, 0, 0
          Cairo.line_to ctx, 400, 300
          Cairo.move_to ctx, 400, 0
          Cairo.line_to ctx, 0, 300
          Cairo.set_line_width ctx, 10
          Cairo.stroke ctx

          Cairo.rectangle ctx, 0, 0, 200, 150
          Cairo.set_source_rgba ctx, 1, 0, 0, 0.80
          Cairo.fill ctx

          Cairo.rectangle ctx, 0, 150, 200, 150
          Cairo.set_source_rgba ctx, 0, 1, 0, 0.60
          Cairo.fill ctx

          Cairo.rectangle ctx, 200, 0, 200, 150
          Cairo.set_source_rgba ctx, 0, 0, 1, 0.40
          Cairo.fill ctx
        when ClientMessage
          break if e.client.data.ul[0] == wm_delete_window
        when KeyPress
          break
        end
      end
    end

    Cairo.destroy ctx
    Cairo.surface_destroy sfc

    X.destroy_window d, win
    X.close_display d
    0
  end

  main
end
