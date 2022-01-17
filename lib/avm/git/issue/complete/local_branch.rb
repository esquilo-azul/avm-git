# frozen_string_literal: true

require 'avm/result'

module Avm
  module Git
    module Issue
      class Complete
        module LocalBranch
          NO_CURRENT_BRANCH_NAME = 'none'

          # Retrieves the current local branch.
          #
          # @return [EacGit::Local::Branch, nil]
          def branch_uncached
            eac_git.current_branch
          end

          def branch_hash_uncached
            branch.if_present(&:current_commit_id)
          end

          def branch_name
            branch.if_present(NO_CURRENT_BRANCH_NAME, &:name)
          end

          def branch_name_result
            ::Avm::Result.success_or_error(issue_id.present?, branch_name)
          end

          def branch_hash_result
            ::Avm::Result.success_or_error(
              branch_hash.present?,
              branch_hash
            )
          end

          def follow_master_result
            return ::Avm::Result.neutral('No branch hash') unless branch_hash

            r = follow_master?
            ::Avm::Result.success_or_error(r, 'yes', 'no')
          end

          def follow_master?
            remote_master_hash ? launcher_git.descendant?(branch_hash, remote_master_hash) : true
          end

          def remove_local_branch
            return unless branch

            info 'Removendo branch local...'
            bn = branch_name
            git_execute(['checkout', branch_hash])
            git_execute(['branch', '-D', bn])
          end
        end
      end
    end
  end
end
