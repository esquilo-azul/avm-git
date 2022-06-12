# frozen_string_literal: true

require 'avm/scms/base'
require 'eac_git/local'
require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module Scms
      class GitSubrepo < ::Avm::Scms::Base
        delegate :commit_if_change, to: :parent_scm

        def update
          git_subrepo.command('clean').execute!
          git_subrepo.command('pull').execute!
        end

        # @return [EacGit::Local]
        def git_repo
          @git_repo ||= ::EacGit::Local.find(path)
        end

        # @return [EacGit::Local::Subrepo]
        def git_subrepo
          @git_subrepo ||= git_repo.subrepo(subpath)
        end

        # @return [Pathname]
        def subpath
          path.expand_path.relative_path_from(git_repo.root_path.expand_path)
        end

        def valid?
          path.join('.gitrepo').file?
        end
      end
    end
  end
end
