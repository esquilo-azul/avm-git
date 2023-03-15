# frozen_string_literal: true

require 'avm/scms/base'
require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module Scms
      class GitSubBase < ::Avm::Scms::Base
        enable_abstract_methods

        delegate :changed_files, :commit_if_change, :current_milestone_base_commit,
                 :head_commit, :reset_and_commit, :run_commit, to: :parent_scm

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
