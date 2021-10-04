# frozen_string_literal: true

require 'avm/git/issue/complete/validation'
require 'avm/result'
require 'ostruct'

module Avm
  module Git
    module Issue
      class Complete
        module Validations
          VALIDATIONS = {
            clean_workspace: 'Clean workspace?',
            branch_name: 'Branch name',
            branch_hash: 'Branch hash',
            follow_master: 'Follow master?',
            commits: 'Commits?',
            bifurcations: 'Bifurcations?',
            dry_push: 'Dry push?',
            git_subrepos: 'Git subrepos ok?',
            test: 'Test ok?'
          }.with_indifferent_access.freeze

          def valid?
            validations.map(&:result).none?(&:error?)
          end

          def validations_banner
            validations.each do |v|
              infov "[#{v.key}] #{v.label}", v.result.label
            end
          end

          def validate_skip_validations
            skip_validations.each do |validation|
              next if VALIDATIONS.keys.include?(validation)

              raise "\"#{validation}\" is not a registered validation"
            end
          end

          private

          def validations_uncached
            VALIDATIONS.map do |key, label|
              ::Avm::Git::Issue::Complete::Validation.new(self, key, label)
            end
          end
        end
      end
    end
  end
end
