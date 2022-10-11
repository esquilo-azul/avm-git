# frozen_string_literal: true

require 'avm/git/launcher_stereotypes/git'
require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module LauncherStereotypes
      class Provider
        STEREOTYPES = [::Avm::Git::LauncherStereotypes::Git].freeze

        def all
          STEREOTYPES
        end
      end
    end
  end
end
