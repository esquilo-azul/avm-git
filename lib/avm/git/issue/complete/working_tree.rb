# frozen_string_literal: true

module Avm
  module Git
    module Issue
      class Complete
        module WorkingTree
          def clean_workspace_result
            ::Avm::Result.success_or_error(clean_workspace?, 'yes', 'no')
          end

          def clean_workspace?
            @git.dirty_files.none?
          end
        end
      end
    end
  end
end
