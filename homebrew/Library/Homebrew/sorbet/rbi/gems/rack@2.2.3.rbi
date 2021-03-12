# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `rack` gem.
# Please instead update this file by running `tapioca sync`.

# typed: true

module Rack
end

class Rack::QueryParser
  def initialize(params_class, key_space_limit, param_depth_limit); end

  def key_space_limit; end
  def make_params; end
  def new_depth_limit(param_depth_limit); end
  def new_space_limit(key_space_limit); end
  def normalize_params(params, name, v, depth); end
  def param_depth_limit; end
  def parse_nested_query(qs, d = T.unsafe(nil)); end
  def parse_query(qs, d = T.unsafe(nil), &unescaper); end

  private

  def params_hash_has_key?(hash, key); end
  def params_hash_type?(obj); end
  def unescape(s); end

  class << self
    def make_default(key_space_limit, param_depth_limit); end
  end
end

Rack::QueryParser::COMMON_SEP = T.let(T.unsafe(nil), Hash)

Rack::QueryParser::DEFAULT_SEP = T.let(T.unsafe(nil), Regexp)

class Rack::QueryParser::InvalidParameterError < ::ArgumentError
end

class Rack::QueryParser::ParameterTypeError < ::TypeError
end

class Rack::QueryParser::Params
  def initialize(limit); end

  def [](key); end
  def []=(key, value); end
  def key?(key); end
  def to_h; end
  def to_params_hash; end
end

module Rack::Utils

  private

  def add_cookie_to_header(header, key, value); end
  def add_remove_cookie_to_header(header, key, value = T.unsafe(nil)); end
  def best_q_match(q_value_header, available_mimes); end
  def build_nested_query(value, prefix = T.unsafe(nil)); end
  def build_query(params); end
  def byte_ranges(env, size); end
  def clean_path_info(path_info); end
  def clock_time; end
  def delete_cookie_header!(header, key, value = T.unsafe(nil)); end
  def escape(s); end
  def escape_html(string); end
  def escape_path(s); end
  def get_byte_ranges(http_range, size); end
  def make_delete_cookie_header(header, key, value); end
  def parse_cookies(env); end
  def parse_cookies_header(header); end
  def parse_nested_query(qs, d = T.unsafe(nil)); end
  def parse_query(qs, d = T.unsafe(nil), &unescaper); end
  def q_values(q_value_header); end
  def rfc2109(time); end
  def rfc2822(time); end
  def secure_compare(a, b); end
  def select_best_encoding(available_encodings, accept_encoding); end
  def set_cookie_header!(header, key, value); end
  def status_code(status); end
  def unescape(s, encoding = T.unsafe(nil)); end
  def unescape_path(s); end
  def valid_path?(path); end

  class << self
    def add_cookie_to_header(header, key, value); end
    def add_remove_cookie_to_header(header, key, value = T.unsafe(nil)); end
    def best_q_match(q_value_header, available_mimes); end
    def build_nested_query(value, prefix = T.unsafe(nil)); end
    def build_query(params); end
    def byte_ranges(env, size); end
    def clean_path_info(path_info); end
    def clock_time; end
    def default_query_parser; end
    def default_query_parser=(_arg0); end
    def delete_cookie_header!(header, key, value = T.unsafe(nil)); end
    def escape(s); end
    def escape_html(string); end
    def escape_path(s); end
    def get_byte_ranges(http_range, size); end
    def key_space_limit; end
    def key_space_limit=(v); end
    def make_delete_cookie_header(header, key, value); end
    def multipart_part_limit; end
    def multipart_part_limit=(_arg0); end
    def param_depth_limit; end
    def param_depth_limit=(v); end
    def parse_cookies(env); end
    def parse_cookies_header(header); end
    def parse_nested_query(qs, d = T.unsafe(nil)); end
    def parse_query(qs, d = T.unsafe(nil), &unescaper); end
    def q_values(q_value_header); end
    def rfc2109(time); end
    def rfc2822(time); end
    def secure_compare(a, b); end
    def select_best_encoding(available_encodings, accept_encoding); end
    def set_cookie_header!(header, key, value); end
    def status_code(status); end
    def unescape(s, encoding = T.unsafe(nil)); end
    def unescape_path(s); end
    def valid_path?(path); end
  end
end

Rack::Utils::COMMON_SEP = T.let(T.unsafe(nil), Hash)

class Rack::Utils::Context
  def initialize(app_f, app_r); end

  def app; end
  def call(env); end
  def context(env, app = T.unsafe(nil)); end
  def for; end
  def recontext(app); end
end

Rack::Utils::DEFAULT_SEP = T.let(T.unsafe(nil), Regexp)

Rack::Utils::ESCAPE_HTML = T.let(T.unsafe(nil), Hash)

Rack::Utils::ESCAPE_HTML_PATTERN = T.let(T.unsafe(nil), Regexp)

Rack::Utils::HTTP_STATUS_CODES = T.let(T.unsafe(nil), Hash)

class Rack::Utils::HeaderHash < ::Hash
  def initialize(hash = T.unsafe(nil)); end

  def [](k); end
  def []=(k, v); end
  def clear; end
  def delete(k); end
  def each; end
  def has_key?(k); end
  def include?(k); end
  def key?(k); end
  def member?(k); end
  def merge(other); end
  def merge!(other); end
  def replace(other); end
  def to_hash; end

  protected

  def names; end

  private

  def initialize_copy(other); end

  class << self
    def [](headers); end
  end
end

Rack::Utils::InvalidParameterError = Rack::QueryParser::InvalidParameterError

Rack::Utils::KeySpaceConstrainedParams = Rack::QueryParser::Params

Rack::Utils::NULL_BYTE = T.let(T.unsafe(nil), String)

Rack::Utils::PATH_SEPS = T.let(T.unsafe(nil), Regexp)

Rack::Utils::ParameterTypeError = Rack::QueryParser::ParameterTypeError

Rack::Utils::STATUS_WITH_NO_ENTITY_BODY = T.let(T.unsafe(nil), Hash)

Rack::Utils::SYMBOL_TO_STATUS_CODE = T.let(T.unsafe(nil), Hash)
