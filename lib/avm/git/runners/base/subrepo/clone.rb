# frozen_string_literal: true

module Avm
  module Git
    module Runners
      class Base
        class Subrepo
          class Clone
            runner_with :help do
              desc 'Clone git-subrepo repositories.'
              arg_opt '-b', '--branch', 'Branch.'
              arg_opt '-d', '--parent-dir', 'Target path\'s parent directory.'
              pos_arg :url
              pos_arg :target_path, optional: true
            end

            def run
              start_banner
              clean
              clone
            end

            private

            def start_banner
              infov 'URL', url
              infov 'Subpath', target_path
              infov 'Branch', branch
            end

            def clean
              infom 'Cleaning...'
              git.command('subrepo', 'clean', '--all', '--force').system!
            end

            def clone
              infom 'Cloning...'
              infov 'Clone arguments', clone_args
              git.command(*clone_args).system!
            end

            delegate :branch, :url, to: :parsed

            def git_uncached
              ::EacGit::Local.new('.')
            end

            def clone_args
              ['subrepo'] + branch.if_present([]) { |v| ['--branch', v] } +
                if ::File.exist?(target_path)
                  ['init', target_path, '--remote', url]
                else
                  ['clone', url, target_path, '--message', clone_message, '--force']
                end
            end

            def clone_message
              "Subrepo \"#{target_path}\" (#{url})."
            end

            def repos_name_from_url
              %r{/([^/]+)\z}.if_match(url, false) { |m| m[1].gsub(/\.git\z/, '') }
            end

            def target_path
              parsed.target_path || target_path_from_parent_dir ||
                fatal_error('No target path specified')
            end

            def target_path_from_parent_dir
              return nil unless parsed.parent_dir && repos_name_from_url

              ::File.join(parsed.parent_dir, repos_name_from_url)
            end
          end
        end
      end
    end
  end
end
