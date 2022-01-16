# frozen_string_literal: true

require 'avm/result'

module Avm
  module Git
    module Issue
      class Complete
        module Commits
          def commits_result
            ::Avm::Result.success_or_error(commits.any?, 'yes', 'none')
          end

          def commits_uncached
            return [] unless branch_hash && follow_master?

            interval = remote_master_hash ? "#{remote_master_hash}..#{branch_hash}" : branch_hash
            launcher_git.execute!('rev-list', interval).each_line.map(&:strip)
          end

          def bifurcations_result
            commits.each do |commit|
              if multiple_parents?(commit)
                return ::Avm::Result.error("#{commit} has multiple parents")
              end
            end
            ::Avm::Result.success('no')
          end

          def multiple_parents?(commit)
            commit_parents(commit).count > 1
          end

          def commit_parents(commit)
            launcher_git.execute!('log', '--pretty=%P', '-n', '1', commit).split(' ').map(&:strip)
                        .select(&:present?)
          end
        end
      end
    end
  end
end
