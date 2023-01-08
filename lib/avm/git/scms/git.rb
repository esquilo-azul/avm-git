# frozen_string_literal: true

require 'avm/git/scms/git_subrepo'
require 'avm/scms/base'
require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module Scms
      class Git < ::Avm::Scms::Base
        require_sub __FILE__, include_modules: true
        include ::Comparable

        COMMIT_DIRTY_DEFAULT_MESSAGE = 'Dirty files.'

        def <=>(other)
          git_repo <=> other.git_repo
        end

        def git_repo
          @git_repo ||= ::EacGit::Local.new(path)
        end

        # @return [Enumerable<Avm::Git::Scms::GitSubrepo>]
        def subs
          git_repo.subrepos.map do |subrepo|
            ::Avm::Git::Scms::GitSubrepo.new(subrepo.subpath.expand_path(path))
          end
        end

        def valid?
          path.join('.git').exist?
        end
      end
    end
  end
end
