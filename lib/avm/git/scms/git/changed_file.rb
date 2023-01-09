# frozen_string_literal: true

require 'avm/scms/changed_file'
require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module Scms
      class Git < ::Avm::Scms::Base
        class ChangedFile < ::Avm::Scms::ChangedFile
          common_constructor :scm, :path
        end
      end
    end
  end
end
