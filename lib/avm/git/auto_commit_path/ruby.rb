# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    class AutoCommitPath
      module Ruby
        RUBY_CLASS_NAME_PATTERNS = [%r{lib/((?!.*/lib/).+)\.rb\z}, %r{app/[^/]+/(.+)\.rb\z}].freeze

        def ruby_class_name
          RUBY_CLASS_NAME_PATTERNS.each do |pattern|
            pattern.if_match(relative_path.to_path, false) { |m| return m[1].camelize }
          end
          nil
        end
      end
    end
  end
end
