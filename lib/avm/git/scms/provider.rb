# frozen_string_literal: true

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
