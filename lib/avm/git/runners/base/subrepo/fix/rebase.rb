# frozen_string_literal: true

require 'shellwords'

module Avm
  module Git
    module Runners
      class Base
        class Subrepo
          class Fix
            class Rebase
              # @!method initialize(local, upstream, commands)
              #   @param local [EacGit::Local]
              #   @param upstream [String]
              #   @param commands [Hash<String, String>] Commands indexed by full commit ID.
              common_constructor :local, :upstream, :commands

              # @return [void]
              def perform
                ::EacRubyUtils::Fs::Temp.on_file do |todo_file|
                  todo_file.write(todo)
                  local.command('rebase', '-i', upstream)
                    .envvar('GIT_SEQUENCE_EDITOR', "cp #{todo_file.to_path.shellescape}").system!
                end
              end

              # @return [String]
              def todo
                commits.flat_map { |commit| commit_lines(commit) }.map { |line| "#{line}\n" }.join
              end

              protected

              # @param commit [String]
              # @return [Array<String>]
              def commit_lines(commit)
                ["pick #{commit}", commands[commit].if_present { |v| "exec #{v}" }].compact
              end

              # @return [Array<String>]
              def commits
                local.command('rev-list', '--reverse', '--no-merges', "#{upstream}..HEAD")
                  .execute!.split
              end
            end
          end
        end
      end
    end
  end
end
