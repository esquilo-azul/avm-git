# frozen_string_literal: true

require 'avm/result'
require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module Issue
      class Complete
        class Validation
          enable_simple_cache
          common_constructor :parent, :key, :label

          SKIPPED_RESULT_MESSAGE = 'skipped'

          def skip?
            parent.skip_validations.include?(key)
          end

          private

          def result_uncached
            skip? ? skipped_result : validation_result
          end

          def skipped_result
            ::Avm::Result.neutral(SKIPPED_RESULT_MESSAGE)
          end

          def validation_result
            parent.send("#{key}_result")
          end
        end
      end
    end
  end
end
