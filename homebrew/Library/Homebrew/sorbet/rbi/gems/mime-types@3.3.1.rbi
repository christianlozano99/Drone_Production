# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `mime-types` gem.
# Please instead update this file by running `tapioca generate --exclude json`.

# typed: true

module MIME
end

class MIME::Type
  include(::Comparable)

  def initialize(content_type); end

  def <=>(other); end
  def add_extensions(*extensions); end
  def ascii?; end
  def binary?; end
  def complete?; end
  def content_type; end
  def default_encoding; end
  def docs; end
  def docs=(_); end
  def encode_with(coder); end
  def encoding; end
  def encoding=(enc); end
  def eql?(other); end
  def extensions; end
  def extensions=(value); end
  def friendly(lang = T.unsafe(nil)); end
  def i18n_key; end
  def init_with(coder); end
  def inspect; end
  def like?(other); end
  def media_type; end
  def obsolete; end
  def obsolete=(_); end
  def obsolete?; end
  def preferred_extension; end
  def preferred_extension=(value); end
  def priority_compare(other); end
  def raw_media_type; end
  def raw_sub_type; end
  def registered; end
  def registered=(_); end
  def registered?; end
  def signature; end
  def signature=(_); end
  def signature?; end
  def simplified; end
  def sub_type; end
  def to_h; end
  def to_json(*args); end
  def to_s; end
  def to_str; end
  def use_instead; end
  def use_instead=(_); end
  def xref_urls; end
  def xrefs; end
  def xrefs=(xrefs); end

  private

  def content_type=(type_string); end
  def intern_string(string); end
  def xref_map(values, helper); end
  def xref_url_for_draft(value); end
  def xref_url_for_person(value); end
  def xref_url_for_rfc(value); end
  def xref_url_for_rfc_errata(value); end
  def xref_url_for_template(value); end

  class << self
    def i18n_key(content_type); end
    def match(content_type); end
    def simplified(content_type, remove_x_prefix: T.unsafe(nil)); end

    private

    def simplify_matchdata(matchdata, remove_x = T.unsafe(nil), joiner: T.unsafe(nil)); end
  end
end

class MIME::Type::Columnar < ::MIME::Type
  def initialize(container, content_type, extensions); end

  def docs(*args); end
  def docs=(*args); end
  def encode_with(coder); end
  def encoding(*args); end
  def encoding=(*args); end
  def friendly(*args); end
  def obsolete(*args); end
  def obsolete=(*args); end
  def obsolete?(*args); end
  def preferred_extension(*args); end
  def preferred_extension=(*args); end
  def registered(*args); end
  def registered=(*args); end
  def registered?(*args); end
  def signature(*args); end
  def signature=(*args); end
  def signature?(*args); end
  def use_instead(*args); end
  def use_instead=(*args); end
  def xref_urls(*args); end
  def xrefs(*args); end
  def xrefs=(*args); end
end

class MIME::Type::InvalidContentType < ::ArgumentError
  def initialize(type_string); end

  def to_s; end
end

class MIME::Type::InvalidEncoding < ::ArgumentError
  def initialize(encoding); end

  def to_s; end
end

MIME::Type::VERSION = T.let(T.unsafe(nil), String)

class MIME::Types
  include(::Enumerable)
  extend(::Enumerable)

  def initialize; end

  def [](type_id, complete: T.unsafe(nil), registered: T.unsafe(nil)); end
  def add(*types); end
  def add_type(type, quiet = T.unsafe(nil)); end
  def count; end
  def each; end
  def inspect; end
  def of(filename); end
  def type_for(filename); end

  private

  def add_type_variant!(mime_type); end
  def index_extensions!(mime_type); end
  def match(pattern); end
  def prune_matches(matches, complete, registered); end
  def reindex_extensions!(mime_type); end

  class << self
    def [](type_id, complete: T.unsafe(nil), registered: T.unsafe(nil)); end
    def add(*types); end
    def count; end
    def each; end
    def logger; end
    def logger=(_); end
    def new(*_); end
    def of(filename); end
    def type_for(filename); end

    private

    def __instances__; end
    def __types__; end
    def lazy_load?; end
    def load_default_mime_types(mode = T.unsafe(nil)); end
    def load_mode; end
    def reindex_extensions(type); end
  end
end

class MIME::Types::Cache < ::Struct
  def data; end
  def data=(_); end
  def version; end
  def version=(_); end

  class << self
    def [](*_); end
    def inspect; end
    def load(cache_file = T.unsafe(nil)); end
    def members; end
    def new(*_); end
    def save(types = T.unsafe(nil), cache_file = T.unsafe(nil)); end
  end
end

module MIME::Types::Columnar
  def load_base_data(path); end

  private

  def arr(line); end
  def dict(line, array: T.unsafe(nil)); end
  def each_file_line(name, lookup = T.unsafe(nil)); end
  def flag(line); end
  def load_docs; end
  def load_encoding; end
  def load_flags; end
  def load_friendly; end
  def load_preferred_extension; end
  def load_use_instead; end
  def load_xrefs; end
  def opt(line); end

  class << self
    def extended(obj); end
  end
end

MIME::Types::Columnar::LOAD_MUTEX = T.let(T.unsafe(nil), Thread::Mutex)

class MIME::Types::Container
  extend(::Forwardable)

  def initialize(hash = T.unsafe(nil)); end

  def ==(*args, &block); end
  def [](key); end
  def []=(key, value); end
  def add(key, value); end
  def count(*args, &block); end
  def each(*args, &block); end
  def each_value(*args, &block); end
  def empty?(*args, &block); end
  def encode_with(coder); end
  def flat_map(*args, &block); end
  def init_with(coder); end
  def keys(*args, &block); end
  def marshal_dump; end
  def marshal_load(hash); end
  def merge(other); end
  def merge!(other); end
  def select(*args, &block); end
  def to_hash; end
  def values(*args, &block); end

  protected

  def container; end
  def container=(_); end
  def normalize; end
end

class MIME::Types::Loader
  def initialize(path = T.unsafe(nil), container = T.unsafe(nil)); end

  def container; end
  def load(options = T.unsafe(nil)); end
  def load_columnar; end
  def load_json; end
  def load_yaml; end
  def path; end

  private

  def columnar_path; end
  def json_path; end
  def yaml_path; end

  class << self
    def load(options = T.unsafe(nil)); end
    def load_from_json(filename); end
    def load_from_yaml(filename); end

    private

    def read_file(filename); end
  end
end

MIME::Types::VERSION = T.let(T.unsafe(nil), String)

class MIME::Types::WarnLogger < ::Logger
  def initialize(_one, _two = T.unsafe(nil), _three = T.unsafe(nil)); end
end

class MIME::Types::WarnLogger::WarnLogDevice < ::Logger::LogDevice
  def initialize(*_); end

  def close; end
  def write(m); end
end
