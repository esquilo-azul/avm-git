# frozen_string_literal: true

require 'avm/git/scms/git/changed_file'
require 'eac_ruby_utils/core_ext'

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

            commit_info = ::Avm::Scms::CommitInfo.assert(commit_info)
            commit_info = commit_info.message(COMMIT_DIRTY_DEFAULT_MESSAGE) if
            commit_info.message.blank?

            git_repo.command('add', '.').execute!
            run_commit(commit_info)
            head_commit
          end
        end
      end
    end
  end
end
