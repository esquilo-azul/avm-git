# frozen_string_literal: true

require 'avm/scms/commit'
require 'eac_ruby_utils'

module Avm
  module Git
    module Scms
      class Git < ::Avm::Scms::Base
        module Commits
          # @return [Avm::Git::Scms::Git::Commit,nil]
          def commit(source)
            if source.is_a?(::Avm::Git::Scms::Git::Commit)
              return source if source.git_repo == git_repo

              raise 'Not same Git repository'
            end
            git_repo.commitize(source).if_present do |v|
              ::Avm::Git::Scms::Git::Commit.new(self, v)
            end
          end

          # @param commit_info [Avm::Scms::CommitInfo]
          # @return [Avm::Git::Scms::Git::Commit,nil]
          def commit_if_change(commit_info = nil)
            tracker = ::Avm::Git::Scms::Git::ChangeTracker.new(self, commit_info)
            tracker.start
            yield
            tracker.stop
          end

          # @return [Avm::Git::Scms::Git::Commit]
          def head_commit
            commit(git_repo.head)
          end

          # @param commit_info [Avm::Scms::CommitInfo]
          # @return [Avm::Git::Scms::Git::Commit]
          def reset_and_commit(commit_to_reset, commit_info)
            git_repo.command('reset', '--soft', commit(commit_to_reset).git_commit.id).execute!
            commit_dirty(commit_info)
          end
        end
      end
    end
  end
end
