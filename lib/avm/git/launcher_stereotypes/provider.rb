# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module LauncherStereotypes
      class Provider
        STEREOTYPES = [].freeze

        def all
          STEREOTYPES
        end
      end
    end
  end
end
