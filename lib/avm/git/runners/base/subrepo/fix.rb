# frozen_string_literal: true

require 'eac_cli'
require 'avm/git/scms/git'
require 'avm/git/subrepo_checks'
require 'avm/scms/auto_commit/rules/unique'
require 'avm/scms/auto_commit/for_file'
require 'eac_git'

module Avm
  module Git
    module Runners
      class Base
        class Subrepo
          class Fix
            runner_with :help do
              desc 'Fix git-subrepos\' parent property.'
            end

            def run
              loop do
                break if fix

                amend_each
                rebase_fixup
              end
            end

            private

            def amend_each
              infov 'Dirty files', local_repos.dirty_files.count
              local_repos.dirty_files.each do |file|
                infov '  * Ammending', file.path
                ::Avm::Scms::AutoCommit::ForFile.new(
                  git_scm, file.path,
                  [::Avm::Scms::AutoCommit::Rules::Unique.new]
                ).run
              end
            end

            def fix
              infom 'Checking/fixing...'
              c = new_check(true)
              c.show_result
              !c.result.error?
            end

            # @return [Avm::Git::Scms::Git]
            def git_scm_uncached
              ::Avm::Git::Scms::Git.new(runner_context.call(:git).root_path)
            end

            def new_check(fix_parent = false) # rubocop:disable Style/OptionalBooleanParameter
              r = ::Avm::Git::SubrepoChecks.new(local_repos).add_all_subrepos
              r.fix_parent = fix_parent
              r
            end

            def local_repos_uncached
              ::EacGit::Local.new(runner_context.call(:git))
            end

            def rebase_fixup
              local_repos.command('rebase', '-i', 'origin/master', '--autosquash').envvar(
                'GIT_SEQUENCE_EDITOR', 'true'
              ).or(
                local_repos.command('rebase', '--continue').envvar('GIT_SEQUENCE_EDITOR', 'true')
              ).system!
            end
          end
        end
      end
    end
  end
end
