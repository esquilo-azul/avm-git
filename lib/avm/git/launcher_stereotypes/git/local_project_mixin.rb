# frozen_string_literal: true

module Avm
  module Git
    module LauncherStereotypes
      class Git
        module LocalProjectMixin
          # @return [EacGit::Local]
          def git_repo
            @git_repo ||= ::EacGit::Local.new(path)
          end
        end
      end
    end
  end
end
