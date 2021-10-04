# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    class SubrepoCheck
      require_sub __FILE__, include_modules: true
      enable_speaker
      enable_simple_cache

      BLANK_TEXT = 'BLANK'

      common_constructor :subrepo, :options

      def blank_text
        BLANK_TEXT
      end

      def check_remote?
        options.fetch(:check_remote) ? true : false
      end

      def fix_parent?
        options.fetch(:fix_parent) ? true : false
      end

      private

      def result_uncached
        return ::Avm::Result.error('Parent failed') if parent_result.error?
        return ::Avm::Result.error('Remote failed') if remote_result.error?

        ::Avm::Result.success('Parent and remote ok')
      end
    end
  end
end
