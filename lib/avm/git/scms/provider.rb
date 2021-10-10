# frozen_string_literal: true

require 'avm/git/scms/git'
require 'avm/git/scms/git_subrepo'
require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module Scms
      class Provider
        SCMS = [::Avm::Git::Scms::Git, ::Avm::Git::Scms::GitSubrepo].freeze

        def all
          SCMS
        end
      end
    end
  end
end
