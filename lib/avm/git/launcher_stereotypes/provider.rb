# frozen_string_literal: true

require 'avm/git/launcher_stereotypes/git'
require 'avm/git/launcher_stereotypes/git_subrepo'
require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module LauncherStereotypes
      class Provider
        STEREOTYPES = [::Avm::Git::LauncherStereotypes::Git,
                       ::Avm::Git::LauncherStereotypes::GitSubrepo].freeze

        def all
          STEREOTYPES
        end
      end
    end
  end
end
