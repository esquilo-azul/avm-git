# frozen_string_literal: true

require 'avm/git/scms/git'
require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module Scms
      class Provider
        SCMS = [::Avm::Git::Scms::Git].freeze

        def all
          SCMS
        end
      end
    end
  end
end
