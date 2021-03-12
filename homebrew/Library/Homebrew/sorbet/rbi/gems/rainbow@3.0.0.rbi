# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `rainbow` gem.
# Please instead update this file by running `tapioca generate --exclude json`.

# typed: true

module Rainbow
  class << self
    def enabled; end
    def enabled=(value); end
    def global; end
    def new; end
    def uncolor(string); end
  end
end

class Rainbow::Color
  def ground; end

  class << self
    def build(ground, values); end
    def parse_hex_color(hex); end
  end
end

class Rainbow::Color::Indexed < ::Rainbow::Color
  def initialize(ground, num); end

  def codes; end
  def num; end
end

class Rainbow::Color::Named < ::Rainbow::Color::Indexed
  def initialize(ground, name); end

  class << self
    def color_names; end
    def valid_names; end
  end
end

Rainbow::Color::Named::NAMES = T.let(T.unsafe(nil), Hash)

class Rainbow::Color::RGB < ::Rainbow::Color::Indexed
  def initialize(ground, *values); end

  def b; end
  def codes; end
  def g; end
  def r; end

  private

  def code_from_rgb; end

  class << self
    def to_ansi_domain(value); end
  end
end

class Rainbow::Color::X11Named < ::Rainbow::Color::RGB
  include(::Rainbow::X11ColorNames)

  def initialize(ground, name); end

  class << self
    def color_names; end
    def valid_names; end
  end
end

class Rainbow::NullPresenter < ::String
  def background(*_values); end
  def bg(*_values); end
  def black; end
  def blink; end
  def blue; end
  def bold; end
  def bright; end
  def color(*_values); end
  def cyan; end
  def dark; end
  def faint; end
  def fg(*_values); end
  def foreground(*_values); end
  def green; end
  def hide; end
  def inverse; end
  def italic; end
  def magenta; end
  def method_missing(method_name, *args); end
  def red; end
  def reset; end
  def underline; end
  def white; end
  def yellow; end

  private

  def respond_to_missing?(method_name, *args); end
end

class Rainbow::Presenter < ::String
  def background(*values); end
  def bg(*values); end
  def black; end
  def blink; end
  def blue; end
  def bold; end
  def bright; end
  def color(*values); end
  def cyan; end
  def dark; end
  def faint; end
  def fg(*values); end
  def foreground(*values); end
  def green; end
  def hide; end
  def inverse; end
  def italic; end
  def magenta; end
  def method_missing(method_name, *args); end
  def red; end
  def reset; end
  def underline; end
  def white; end
  def yellow; end

  private

  def respond_to_missing?(method_name, *args); end
  def wrap_with_sgr(codes); end
end

Rainbow::Presenter::TERM_EFFECTS = T.let(T.unsafe(nil), Hash)

class Rainbow::StringUtils
  class << self
    def uncolor(string); end
    def wrap_with_sgr(string, codes); end
  end
end

class Rainbow::Wrapper
  def initialize(enabled = T.unsafe(nil)); end

  def enabled; end
  def enabled=(_); end
  def wrap(string); end
end

module Rainbow::X11ColorNames
end

Rainbow::X11ColorNames::NAMES = T.let(T.unsafe(nil), Hash)
