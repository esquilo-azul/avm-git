# frozen_string_literal: true

require 'avm/scms/remote'
require 'eac_ruby_utils/core_ext'

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
