# frozen_string_literal: true

require 'eac_cli/core_ext'
require 'avm/git/launcher/base'

module Avm
  module Git
    module Runners
      class Base
        require_sub __FILE__
        runner_with :help, :subcommands do
          desc 'Git utilities for AVM.'
          arg_opt '-C', '--path', 'Path to Git repository.'
          subcommands
        end

        def repository_path
          repository_path? ? parsed.path : '.'
        end

        def repository_path?
          parsed.path.present?
        end

        def git
          @git ||= ::Avm::Git::Launcher::Base.by_root(repository_path)
        end

        # @return [[EacGit::Local]]
        def git_repo
          git.eac_git
        end
      end
    end
  end
end
