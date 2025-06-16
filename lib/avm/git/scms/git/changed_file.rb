# frozen_string_literal: true

module Avm
  module Git
    module Scms
      class Git < ::Avm::Scms::Base
        class ChangedFile < ::Avm::Scms::ChangedFile
          common_constructor :scm, :sub_changed_file

          # @return [Pathname]
          delegate :path, to: :sub_changed_file

          # @return [Symbol]
          def action
            return ACTION_ADD if sub_changed_file.add?
            return ACTION_DELETE if sub_changed_file.delete?
            return ACTION_MODIFY if sub_changed_file.modify?

            nyi sub_changed_file
          end
        end
      end
    end
  end
end
