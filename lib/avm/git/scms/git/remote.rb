# frozen_string_literal: true

module Avm
  module Git
    module Scms
      class Git < ::Avm::Scms::Base
        class Remote < ::Avm::Scms::Remote
          common_constructor :scm, :eac_git_remote

          # @return [String]
          def id
            nyi eac_git_remote
          end
        end
      end
    end
  end
end
