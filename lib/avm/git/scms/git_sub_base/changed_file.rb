# frozen_string_literal: true

module Avm
  module Git
    module Scms
      class GitSubBase < ::Avm::Scms::Base
        class ChangedFile < ::Avm::Scms::ChangedFile
          common_constructor :scm, :parent_changed_file

          # @return [Pathname]
          def path
            parent_changed_file.path.relative_path_from(scm.relative_path_from_parent_scm)
          end
        end
      end
    end
  end
end
