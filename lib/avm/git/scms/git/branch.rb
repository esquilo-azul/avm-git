# frozen_string_literal: true

require 'avm/scms/branch'
require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module Scms
      class Git < ::Avm::Scms::Base
        class Branch < ::Avm::Scms::Branch
          common_constructor :scm, :eac_git_branch

          # @return [Avm::Git::Scms::Git::Commit]
          def head_commit
            ::Avm::Git::Scms::Git::Commit.new(scm, eac_git_branch.head_commit)
          end

          # @return [String]
          def id
            eac_git_branch.name
          end

          # @param remote [Avm::Git::Scms::Git::Remote]
          def push(remote)
            eac_git_branch.push(remote.eac_git_remote, force: true)
          end
        end
      end
    end
  end
end
