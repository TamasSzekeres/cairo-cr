require "./c/lib_cairo"
require "./c/features"

{% if Cairo::C::HAS_SCRIPT_SURFACE %}

module Cairo
  # A set of script output variants.
  enum ScriptMode
    # The output will be in readable text (default).
    Ascii

    # The output will use byte codes.
    Binary
  end
end

{% end %}
