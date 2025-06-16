# frozen_string_literal: true

module Avm
  module Git
    module Scms
      class Git < ::Avm::Scms::Base
        class ChangedFile < ::Avm::Scms::ChangedFile
          common_constructor :scm, :sub_changed_file

          # @return [Pathname]
          delegate :path, to: :sub_changed_file
        end
      end
    end
  end
end
