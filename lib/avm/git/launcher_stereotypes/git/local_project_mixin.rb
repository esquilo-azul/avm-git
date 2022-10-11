# frozen_string_literal: true

require 'eac_git/local'
require 'eac_ruby_utils/core_ext'

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
