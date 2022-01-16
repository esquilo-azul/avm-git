# frozen_string_literal: true

require 'avm/git/subrepo_checks'
require 'eac_git/local'

module Avm
  module Git
    module Issue
      class Complete
        module GitSubrepos
          def git_subrepos_result
            return ::Avm::Result.error('Unclean workspace') unless clean_workspace?

            infom 'Checking Git subrepos...'
            r = ::Avm::Git::SubrepoChecks.new(::EacGit::Local.new(launcher_git)).add_all_subrepos
            r.check_remote = true
            r.result
          end
        end
      end
    end
  end
end
