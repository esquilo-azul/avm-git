# frozen_string_literal: true

require 'shellwords'

module Avm
  module Git
    module Runners
      class Base
        class Subrepo
          class Fix
            UPSTREAM = 'origin/master'

            runner_with :help do
              desc 'Fix git-subrepos\' parent property.'
            end

            def run
              return unless check_failed?

              rebase
              fatal_error 'Failed' if check_failed?
            end

            private

            # @return [Boolean]
            def check_failed?
              infom 'Checking...'
              checks = ::Avm::Git::Subrepo::Checks.new(local_repos).add_all_subrepos
              checks.show_result
              checks.result.error?
            end

            # @param subrepos [Array<EacGit::Local::Subrepo>]
            # @return [String]
            def fix_parent_command(subrepos)
              paths = subrepos.map { |subrepo| subrepo.config_relative_path.to_path.shellescape }
              paths.map { |path| fix_parent_path_command(path) }
                .push("git add -- #{paths.join(' ')}", 'git commit --amend --no-edit')
                .join(' && ')
            end

            # @param path [String]
            # @return [String]
            def fix_parent_path_command(path)
              "git config --file=#{path} subrepo.parent \"$(git rev-parse HEAD^)\""
            end

            # @param subrepo [EacGit::Local::Subrepo]
            # @return [String]
            def last_config_change(subrepo)
              local_repos.command('log', '-n', '1', '--pretty=format:%H', '--',
                                  subrepo.config_relative_path.to_path).execute!.strip
            end

            # @return [EacGit::Local]
            memoize def local_repos
              ::EacGit::Local.new(runner_context.call(:git))
            end

            # @return [void]
            def rebase
              ::Avm::Git::Runners::Base::Subrepo::Fix::Rebase.new(
                local_repos, UPSTREAM,
                subrepos_by_last_config_change.transform_values { |v| fix_parent_command(v) }
              ).perform
            end

            # @return [Hash<String, Array<EacGit::Local::Subrepo>>]
            memoize def subrepos_by_last_config_change
              local_repos.subrepos.group_by { |subrepo| last_config_change(subrepo) }
            end
          end
        end
      end
    end
  end
end
