# frozen_string_literal: true

require 'avm/git/scms/git'
require 'avm/git/scms/git_subrepo'
require 'avm/git/scms/git_subtree'
require 'eac_ruby_utils'

module Avm
  module Git
    module Scms
      class Provider
        SCMS = [::Avm::Git::Scms::Git, ::Avm::Git::Scms::GitSubrepo,
                ::Avm::Git::Scms::GitSubtree].freeze

        def all
          SCMS
        end
      end
    end
  end
end
