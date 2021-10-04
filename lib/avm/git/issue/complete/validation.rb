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

          def skip?
            parent.skip_validations.include?(key)
          end

          private

          def result_uncached
            if skip?
              ::Avm::Result.neutral('skipped')
            else
              parent.send("#{key}_result")
            end
          end
        end
      end
    end
  end
end
