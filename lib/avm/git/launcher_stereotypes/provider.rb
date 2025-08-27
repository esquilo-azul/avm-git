# frozen_string_literal: true

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
