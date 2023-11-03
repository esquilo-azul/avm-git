# frozen_string_literal: true

require 'avm/git/scms/provider'
require 'avm/git/scms/git_sub_base'
require 'avm/scms/base'
require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module Scms
      class GitSubtree < ::Avm::Git::Scms::GitSubBase
        def update
          # Do nothing
        end

        def valid?
          return false unless ::Avm::Git::Scms::Provider
                                .new.all.any? { |scm_class| parent_scm.is_a?(scm_class) }

          (::Avm::Git::Scms::Provider.new.all - [self.class])
            .lazy.map { |scm_class| scm_class.new(path) }.none?(&:valid?)
        end
      end
    end
  end
end
