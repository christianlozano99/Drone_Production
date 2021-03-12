# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `tzinfo` gem.
# Please instead update this file by running `tapioca sync`.

# typed: true

module TZInfo
end

class TZInfo::AbsoluteDayOfYearTransitionRule
  def initialize(day, transition_at = T.unsafe(nil)); end

  def ==(r); end
  def eql?(r); end
  def is_always_first_day_of_year?; end
  def is_always_last_day_of_year?; end

  protected

  def get_day(offset, year); end
  def hash_args; end
end

class TZInfo::AmbiguousTime < ::StandardError
end

class TZInfo::Country
  include(::Comparable)

  def initialize(info); end

  def <=>(c); end
  def =~(regexp); end
  def _dump(limit); end
  def code; end
  def eql?(c); end
  def hash; end
  def inspect; end
  def name; end
  def to_s; end
  def zone_identifiers; end
  def zone_info; end
  def zone_names; end
  def zones; end

  class << self
    def _load(data); end
    def all; end
    def all_codes; end
    def get(code); end

    private

    def data_source; end
  end
end

class TZInfo::CountryTimezone
  def initialize(identifier, latitude, longitude, description = T.unsafe(nil)); end

  def ==(ct); end
  def description; end
  def description_or_friendly_identifier; end
  def eql?(ct); end
  def hash; end
  def identifier; end
  def latitude; end
  def longitude; end
  def timezone; end
end

class TZInfo::DataSource
  def initialize; end

  def country_codes; end
  def data_timezone_identifiers; end
  def get_country_info(code); end
  def get_timezone_info(identifier); end
  def inspect; end
  def linked_timezone_identifiers; end
  def timezone_identifiers; end
  def to_s; end

  protected

  def load_country_info(code); end
  def load_timezone_info(identifier); end
  def lookup_country_info(hash, code, encoding = T.unsafe(nil)); end
  def timezone_identifier_encoding; end
  def validate_timezone_identifier(identifier); end

  private

  def build_timezone_identifiers; end
  def find_timezone_identifier(identifier); end
  def raise_invalid_data_source(method_name); end
  def try_with_encoding(string, encoding); end

  class << self
    def get; end
    def set(data_source_or_type, *args); end

    private

    def create_default_data_source; end
  end
end

class TZInfo::DataSourceNotFound < ::StandardError
end

module TZInfo::DataSources
end

class TZInfo::DataSources::ConstantOffsetDataTimezoneInfo < ::TZInfo::DataSources::DataTimezoneInfo
  def initialize(identifier, constant_offset); end

  def constant_offset; end
  def period_for(timestamp); end
  def periods_for_local(local_timestamp); end
  def transitions_up_to(to_timestamp, from_timestamp = T.unsafe(nil)); end

  private

  def constant_period; end
end

class TZInfo::DataSources::CountryInfo
  def initialize(code, name, zones); end

  def code; end
  def inspect; end
  def name; end
  def zones; end
end

class TZInfo::DataSources::DataTimezoneInfo < ::TZInfo::DataSources::TimezoneInfo
  def create_timezone; end
  def period_for(timestamp); end
  def periods_for_local(local_timestamp); end
  def transitions_up_to(to_timestamp, from_timestamp = T.unsafe(nil)); end

  private

  def raise_not_implemented(method_name); end
end

class TZInfo::DataSources::InvalidZoneinfoDirectory < ::StandardError
end

class TZInfo::DataSources::InvalidZoneinfoFile < ::StandardError
end

class TZInfo::DataSources::LinkedTimezoneInfo < ::TZInfo::DataSources::TimezoneInfo
  def initialize(identifier, link_to_identifier); end

  def create_timezone; end
  def link_to_identifier; end
end

class TZInfo::DataSources::RubyDataSource < ::TZInfo::DataSource
  def initialize; end

  def country_codes; end
  def data_timezone_identifiers; end
  def inspect; end
  def linked_timezone_identifiers; end
  def to_s; end

  protected

  def load_country_info(code); end
  def load_timezone_info(identifier); end

  private

  def require_data(*file); end
  def require_definition(identifier); end
  def require_index(name); end
  def version_info; end
end

class TZInfo::DataSources::TZInfoDataNotFound < ::StandardError
end

class TZInfo::DataSources::TimezoneInfo
  def initialize(identifier); end

  def create_timezone; end
  def identifier; end
  def inspect; end

  private

  def raise_not_implemented(method_name); end
end

class TZInfo::DataSources::TransitionsDataTimezoneInfo < ::TZInfo::DataSources::DataTimezoneInfo
  def initialize(identifier, transitions); end

  def period_for(timestamp); end
  def periods_for_local(local_timestamp); end
  def transitions; end
  def transitions_up_to(to_timestamp, from_timestamp = T.unsafe(nil)); end

  private

  def find_minimum_transition(&block); end
  def transition_on_or_after_timestamp?(transition, timestamp); end
end

class TZInfo::DataSources::ZoneinfoDataSource < ::TZInfo::DataSource
  def initialize(zoneinfo_dir = T.unsafe(nil), alternate_iso3166_tab_path = T.unsafe(nil)); end

  def country_codes; end
  def data_timezone_identifiers; end
  def inspect; end
  def linked_timezone_identifiers; end
  def to_s; end
  def zoneinfo_dir; end

  protected

  def load_country_info(code); end
  def load_timezone_info(identifier); end

  private

  def dms_to_rational(sign, degrees, minutes, seconds = T.unsafe(nil)); end
  def enum_timezones(dir, exclude = T.unsafe(nil), &block); end
  def find_zoneinfo_dir; end
  def load_countries(iso3166_tab_path, zone_tab_path); end
  def load_timezone_identifiers; end
  def resolve_tab_path(zoneinfo_path, standard_names, tab_name); end
  def validate_zoneinfo_dir(path, iso3166_tab_path = T.unsafe(nil)); end

  class << self
    def alternate_iso3166_tab_search_path; end
    def alternate_iso3166_tab_search_path=(alternate_iso3166_tab_search_path); end
    def search_path; end
    def search_path=(search_path); end

    private

    def process_search_path(path, default); end
  end
end

class TZInfo::DataSources::ZoneinfoDirectoryNotFound < ::StandardError
end

class TZInfo::DataTimezone < ::TZInfo::InfoTimezone
  def canonical_zone; end
  def period_for(time); end
  def periods_for_local(local_time); end
  def transitions_up_to(to, from = T.unsafe(nil)); end
end

class TZInfo::DateTimeWithOffset < ::DateTime
  include(::TZInfo::WithOffset)

  def downto(min); end
  def england; end
  def gregorian; end
  def italy; end
  def julian; end
  def new_start(start = T.unsafe(nil)); end
  def set_timezone_offset(timezone_offset); end
  def step(limit, step = T.unsafe(nil)); end
  def timezone_offset; end
  def to_time; end
  def upto(max); end

  protected

  def clear_timezone_offset; end
end

class TZInfo::InfoTimezone < ::TZInfo::Timezone
  def initialize(info); end

  def identifier; end

  protected

  def info; end
end

class TZInfo::InvalidCountryCode < ::StandardError
end

class TZInfo::InvalidDataSource < ::StandardError
end

class TZInfo::InvalidTimezoneIdentifier < ::StandardError
end

class TZInfo::LinkedTimezone < ::TZInfo::InfoTimezone
  def initialize(info); end

  def canonical_zone; end
  def period_for(time); end
  def periods_for_local(local_time); end
  def transitions_up_to(to, from = T.unsafe(nil)); end
end

class TZInfo::OffsetTimezonePeriod < ::TZInfo::TimezonePeriod
  def initialize(offset); end

  def ==(p); end
  def end_transition; end
  def eql?(p); end
  def hash; end
  def start_transition; end
end

class TZInfo::PeriodNotFound < ::StandardError
end

class TZInfo::TimeWithOffset < ::Time
  include(::TZInfo::WithOffset)

  def dst?; end
  def getlocal(*args); end
  def gmtime; end
  def isdst; end
  def localtime(*args); end
  def round(ndigits = T.unsafe(nil)); end
  def set_timezone_offset(timezone_offset); end
  def timezone_offset; end
  def to_a; end
  def to_datetime; end
  def utc; end
  def zone; end

  protected

  def clear_timezone_offset; end
end

class TZInfo::Timestamp
  include(::Comparable)

  def initialize(value, sub_second = T.unsafe(nil), utc_offset = T.unsafe(nil)); end

  def <=>(t); end
  def add_and_set_utc_offset(seconds, utc_offset); end
  def eql?(_arg0); end
  def hash; end
  def inspect; end
  def strftime(format); end
  def sub_second; end
  def to_datetime; end
  def to_i; end
  def to_s; end
  def to_time; end
  def utc; end
  def utc?; end
  def utc_offset; end
  def value; end

  protected

  def new_datetime(klass = T.unsafe(nil)); end
  def new_time(klass = T.unsafe(nil)); end

  private

  def initialize!(value, sub_second = T.unsafe(nil), utc_offset = T.unsafe(nil)); end
  def sub_second_to_s; end
  def value_and_sub_second_to_s(offset = T.unsafe(nil)); end

  class << self
    def create(year, month = T.unsafe(nil), day = T.unsafe(nil), hour = T.unsafe(nil), minute = T.unsafe(nil), second = T.unsafe(nil), sub_second = T.unsafe(nil), utc_offset = T.unsafe(nil)); end
    def for(value, offset = T.unsafe(nil)); end
    def utc(value, sub_second = T.unsafe(nil)); end

    private

    def for_datetime(datetime, ignore_offset, target_utc_offset); end
    def for_time(time, ignore_offset, target_utc_offset); end
    def for_time_like(time_like, ignore_offset, target_utc_offset); end
    def for_timestamp(timestamp, ignore_offset, target_utc_offset); end
    def is_time_like?(value); end
    def new!(value, sub_second = T.unsafe(nil), utc_offset = T.unsafe(nil)); end
  end
end

class TZInfo::TimestampWithOffset < ::TZInfo::Timestamp
  include(::TZInfo::WithOffset)

  def set_timezone_offset(timezone_offset); end
  def timezone_offset; end
  def to_datetime; end
  def to_time; end

  class << self
    def set_timezone_offset(timestamp, timezone_offset); end
  end
end

class TZInfo::Timezone
  include(::Comparable)

  def <=>(tz); end
  def =~(regexp); end
  def _dump(limit); end
  def abbr(time = T.unsafe(nil)); end
  def abbreviation(time = T.unsafe(nil)); end
  def base_utc_offset(time = T.unsafe(nil)); end
  def canonical_identifier; end
  def canonical_zone; end
  def current_period; end
  def current_period_and_time; end
  def current_time_and_period; end
  def dst?(time = T.unsafe(nil)); end
  def eql?(tz); end
  def friendly_identifier(skip_first_part = T.unsafe(nil)); end
  def hash; end
  def identifier; end
  def inspect; end
  def local_datetime(year, month = T.unsafe(nil), day = T.unsafe(nil), hour = T.unsafe(nil), minute = T.unsafe(nil), second = T.unsafe(nil), sub_second = T.unsafe(nil), dst = T.unsafe(nil), &block); end
  def local_time(year, month = T.unsafe(nil), day = T.unsafe(nil), hour = T.unsafe(nil), minute = T.unsafe(nil), second = T.unsafe(nil), sub_second = T.unsafe(nil), dst = T.unsafe(nil), &block); end
  def local_timestamp(year, month = T.unsafe(nil), day = T.unsafe(nil), hour = T.unsafe(nil), minute = T.unsafe(nil), second = T.unsafe(nil), sub_second = T.unsafe(nil), dst = T.unsafe(nil), &block); end
  def local_to_utc(local_time, dst = T.unsafe(nil)); end
  def name; end
  def now; end
  def observed_utc_offset(time = T.unsafe(nil)); end
  def offsets_up_to(to, from = T.unsafe(nil)); end
  def period_for(time); end
  def period_for_local(local_time, dst = T.unsafe(nil)); end
  def period_for_utc(utc_time); end
  def periods_for_local(local_time); end
  def strftime(format, time = T.unsafe(nil)); end
  def to_local(time); end
  def to_s; end
  def transitions_up_to(to, from = T.unsafe(nil)); end
  def utc_offset(time = T.unsafe(nil)); end
  def utc_to_local(utc_time); end

  private

  def raise_unknown_timezone; end

  class << self
    def _load(data); end
    def all; end
    def all_country_zone_identifiers; end
    def all_country_zones; end
    def all_data_zone_identifiers; end
    def all_data_zones; end
    def all_identifiers; end
    def all_linked_zone_identifiers; end
    def all_linked_zones; end
    def default_dst; end
    def default_dst=(value); end
    def get(identifier); end
    def get_proxy(identifier); end

    private

    def data_source; end
    def get_proxies(identifiers); end
  end
end

class TZInfo::TimezoneOffset
  def initialize(base_utc_offset, std_offset, abbreviation); end

  def ==(toi); end
  def abbr; end
  def abbreviation; end
  def base_utc_offset; end
  def dst?; end
  def eql?(toi); end
  def hash; end
  def inspect; end
  def observed_utc_offset; end
  def std_offset; end
  def utc_offset; end
  def utc_total_offset; end
end

class TZInfo::TimezonePeriod
  def initialize(offset); end

  def abbr; end
  def abbreviation; end
  def base_utc_offset; end
  def dst?; end
  def end_transition; end
  def ends_at; end
  def local_ends_at; end
  def local_starts_at; end
  def observed_utc_offset; end
  def offset; end
  def start_transition; end
  def starts_at; end
  def std_offset; end
  def utc_offset; end
  def utc_total_offset; end
  def zone_identifier; end

  private

  def raise_not_implemented(method_name); end
  def timestamp(transition); end
  def timestamp_with_offset(transition); end
end

class TZInfo::TimezoneProxy < ::TZInfo::Timezone
  def initialize(identifier); end

  def _dump(limit); end
  def canonical_zone; end
  def identifier; end
  def period_for(time); end
  def periods_for_local(local_time); end
  def transitions_up_to(to, from = T.unsafe(nil)); end

  private

  def real_timezone; end

  class << self
    def _load(data); end
  end
end

class TZInfo::TimezoneTransition
  def initialize(offset, previous_offset, timestamp_value); end

  def ==(tti); end
  def at; end
  def eql?(tti); end
  def hash; end
  def local_end_at; end
  def local_start_at; end
  def offset; end
  def previous_offset; end
  def timestamp_value; end
end

class TZInfo::TransitionsTimezonePeriod < ::TZInfo::TimezonePeriod
  def initialize(start_transition, end_transition); end

  def ==(p); end
  def end_transition; end
  def eql?(p); end
  def hash; end
  def inspect; end
  def start_transition; end
end

class TZInfo::UnknownTimezone < ::StandardError
end

TZInfo::VERSION = T.let(T.unsafe(nil), String)

module TZInfo::WithOffset
  def strftime(format); end

  protected

  def if_timezone_offset(result = T.unsafe(nil)); end
end
