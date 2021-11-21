# frozen_string_literal: true

require 'avm/sources/configuration'
require 'avm/result'
require 'avm/sources/base'
require 'avm/sources/tests/builder'
require 'eac_ruby_utils/fs/temp'

module Avm
  module Git
    module Issue
      class Complete
        module Test
          def test_result
            infom 'Running tests...'
            test_performer.units.each do |single|
              return ::Avm::Result.error(test_failed_result_message(single)) if single.failed?
            end
            ::Avm::Result.success('all passed')
          end

          private

          def test_failed_result_message(single)
            { 'Source' => single, 'STDOUT' => single.logs[:stdout],
              'STDERR' => single.logs[:stderr] }.map { |k, v| "#{k}: #{v}" }.join(', ')
          end

          def test_performer
            ::Avm::Sources::Tests::Builder
              .new(::Avm::Registry.sources.detect(@git))
              .include_main(true)
              .include_subs(true)
              .performer
          end
        end
      end
    end
  end
end
