# frozen_string_literal: true

module Avm
  module Git
    module Scms
      class Git < ::Avm::Scms::Base
        class CommitDirty
          enable_method_class
          # @param commit_info [Avm::Scms::CommitInfo, nil]
          common_constructor :scm, :commit_info, default: [nil]
          delegate :git_repo, :head_commit, :run_commit, to: :scm

          # @return [Avm::Git::Scms::Git::Commit,nil]
          def result
            return nil unless git_repo.dirty?

            run_commit(asserted_commit_info)
            head_commit
          end

          private

          def asserted_commit_info
            r = ::Avm::Scms::CommitInfo.assert(commit_info)
            r = r.message(COMMIT_DIRTY_DEFAULT_MESSAGE) if r.message.blank?
            git_repo.dirty_files.inject(r) { |a, e| a.path(e.absolute_path) }
          end
        end
      end
    end
  end
end
