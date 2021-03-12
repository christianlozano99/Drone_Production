# frozen_string_literal: true

require 'yaml'

module RuboCop
  module RSpec
    # Builds a YAML config file from two config hashes
    class ConfigFormatter
      EXTENSION_ROOT_DEPARTMENT = %r{^(RSpec/)}.freeze
      STYLE_GUIDE_BASE_URL = 'https://www.rubydoc.info/gems/rubocop-rspec/RuboCop/Cop/RSpec/'

      def initialize(config, descriptions)
        @config       = config
        @descriptions = descriptions
      end

      def dump
        YAML.dump(unified_config)
          .gsub(EXTENSION_ROOT_DEPARTMENT, "\n\\1")
          .gsub(/^(\s+)- /, '\1  - ')
      end

      private

      def unified_config
        cops.each_with_object(config.dup) do |cop, unified|
          unified[cop] = config.fetch(cop)
            .merge(descriptions.fetch(cop))
            .merge('StyleGuide' => STYLE_GUIDE_BASE_URL + cop.sub('RSpec/', ''))
        end
      end

      def cops
        (descriptions.keys | config.keys).grep(EXTENSION_ROOT_DEPARTMENT)
      end

      attr_reader :config, :descriptions
    end
  end
end
