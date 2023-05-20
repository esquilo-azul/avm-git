# frozen_string_literal: true

require 'avm/scms/commit'
require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module Scms
      class Git < ::Avm::Scms::Base
        class RunCommit
          enable_method_class

          common_constructor :scm, :commit_info

          # @return [Avm::Git::Scms::Git::Commit]
          def result
            reset
            add_paths
            commit

            scm.head_commit
          end

          protected

          def add_path(path)
            scm.git_repo.command(
              *(path.exist? ? ['add'] : ['rm', '-f']),
              path.relative_path_from(scm.path)
            ).execute!
          end

          def add_paths
            commit_info.paths.each { |path| add_path(path) }
          end

          def commit
            scm.git_repo.command('commit', *commit_args).execute!
          end

          # @return [Array<String>]
          def commit_args
            r = commit_info.fixup.if_present([]) { |v| ['--fixup', v.id] }
            r += commit_info.message.if_present([]) { |v| ['--message', v] }
            return r if r.any?

            raise 'Argument list is empty'
          end

          def reset
            scm.git_repo.command('reset', 'HEAD').execute!
          end
        end
      end
    end
  end
end
