# frozen_string_literal: true

require 'avm/git/scms/provider'
require 'avm/git/scms/git_sub_base'
require 'avm/scms/base'
require 'eac_ruby_utils'

module Avm
  module Git
    module Scms
      class GitSubtree < ::Avm::Git::Scms::GitSubBase
        # @return [Boolean]
        def no_other_git_scm?
          (::Avm::Git::Scms::Provider.new.all - [self.class])
            .lazy.map { |scm_class| scm_class.new(path) }.none?(&:valid?)
        end

        # @return [Boolean]
        def parent_git_scm?
          ::Avm::Git::Scms::Provider.new.all.any? { |scm_class| parent_scm.is_a?(scm_class) }
        end

        def update
          # Do nothing
        end

        # @return [Boolean]
        def valid?
          parent_git_scm? && no_other_git_scm?
        end
      end
    end
  end
end
