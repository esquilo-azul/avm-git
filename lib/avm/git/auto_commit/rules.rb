# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

::EacRubyUtils.require_sub __FILE__

module Avm
  module Git
    module AutoCommit
      module Rules
        RULES_CLASSES = %w[last manual new nth unique]
                        .map { |key| ::Avm::Git::AutoCommit::Rules.const_get(key.camelcase) }

        class << self
          def parse(string)
            parts = string.split(':')

            klass = rule_class_by_key(parts.shift)
            klass.new(*parts)
          end

          def rule_class_by_key(key)
            RULES_CLASSES.find { |klass| klass.keys.include?(key) } ||
              raise("Rule not find with key \"#{key}\" (Available: " +
                RULES_CLASSES.flat_map(&:keys).join(', ') + ')')
          end
        end
      end
    end
  end
end
