# frozen_string_literal: true

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
          rescue ::RuntimeError => e
            ::Avm::Result.error("error raised: #{e.message}")
          end
        end
      end
    end
  end
end
