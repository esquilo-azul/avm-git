# frozen_string_literal: true

module Avm
  module Git
    module Scms
      class GitSubrepo < ::Avm::Git::Scms::GitSubBase
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
