# frozen_string_literal: true

require 'avm/git/launcher_stereotypes/git'
require 'avm/git/launcher_stereotypes/git_subrepo'
require 'avm/git/launcher_stereotypes/git_subtree'
require 'eac_ruby_utils'

module Avm
  module Git
    module LauncherStereotypes
      class Provider
        STEREOTYPES = [::Avm::Git::LauncherStereotypes::Git,
                       ::Avm::Git::LauncherStereotypes::GitSubrepo,
                       ::Avm::Git::LauncherStereotypes::GitSubtree].freeze

        def all
          STEREOTYPES
        end
      end
    end
  end
end
