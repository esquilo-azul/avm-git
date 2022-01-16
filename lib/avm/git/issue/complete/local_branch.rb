# frozen_string_literal: true

require 'avm/result'

module Avm
  module Git
    module Issue
      class Complete
        module LocalBranch
          def branch_uncached
            launcher_git.current_branch
          end

          def branch_hash_uncached
            launcher_git.rev_parse("refs/heads/#{branch}")
          end

          def branch_name
            branch.split('/')[-1]
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
            info 'Removendo branch local...'
            bn = branch_name
            git(['checkout', branch_hash])
            git(['branch', '-D', bn])
          end
        end
      end
    end
  end
end
