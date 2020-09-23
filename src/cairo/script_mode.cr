require "./c/lib_cairo"
require "./c/features"

{% if Cairo::C::HAS_SCRIPT_SURFACE %}

module Cairo
  enum ScriptMode
    Ascii
    Binary
  end
end

{% end %}
