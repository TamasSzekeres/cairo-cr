require "cairo"

at_exit do
  GC.collect
end


module SvgDrawing
  include Cairo

  def self.main
    # Create a new SvgSurface and specify a filename and dimensions
    surface = Cairo::SvgSurface.new "test.svg", 400, 300

    # (Optional) Restrict which version of SVG that Cairo should use.
    surface.restrict_to_version Cairo::SvgVersion::V_1_2

    # Create a context based on the surface
    ctx = Cairo::Context.new surface


    # Draw some nice shapes
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

    # Finish the surface by calling surface.finish
    surface.finish
  end

  main
end
