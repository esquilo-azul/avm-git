# frozen_string_literal: true

require 'eac_cli'
require 'eac_git'

module Avm
  module Git
    module Runners
      class Base
        class Subrepo
          class Check
            runner_with :help do
              desc 'Check status of subrepos.'
              bool_opt '-a', '--all', 'Select all subrepos.'
              bool_opt '-f', '--fix-parent', 'Fix parent SHA1.'
              bool_opt '-n', '--no-error', 'Do not exit with error if check fails.'
              bool_opt '-r', '--remote', 'Check subrepos remote.'
              pos_arg :subrepos, repeat: true, optional: true
            end

            def run
              subrepo_checks.show_result
              return if parsed.no_error?
              return unless subrepo_checks.result.error?

              fatal_error 'Failed'
            end

            private

            def subrepo_checks_uncached
              r = ::Avm::Git::SubrepoChecks.new(local_repos)
              r.check_remote = parsed.remote?
              r.fix_parent = parsed.fix_parent?
              r.add_all_subrepos if parsed.all?
              r.add_subrepos(*parsed.subrepos)
              r
            end

            def local_repos_uncached
              ::EacGit::Local.new(runner_context.call(:git))
            end
          end
        end
      end
    end
  end
end
