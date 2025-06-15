# frozen_string_literal: true

module Avm
  module Git
    module Scms
      class GitSubBase < ::Avm::Scms::Base
        enable_abstract_methods

        delegate :commit_if_change, :current_milestone_base_commit,
                 :head_commit, :reset_and_commit, :run_commit, to: :parent_scm

        # @return [Enumerable<Avm::Git::Scms::GitSubBase::ChangedFile>]
        def changed_files
          parent_scm.changed_files.map do |parent_changed_file|
            ::Avm::Git::Scms::GitSubBase::ChangedFile.new(self, parent_changed_file)
          end
        end

        # @param from [Avm::Git::Scms::Git::Commit]
        # @param to [Avm::Git::Scms::Git::Commit]
        # @return [Avm::Git::Scms::GitSubBase::Interval]
        def interval(from, to)
          ::Avm::Git::Scms::GitSubBase::Interval.new(self, from, to)
        end

        require_sub __FILE__
      end
    end
  end
end
