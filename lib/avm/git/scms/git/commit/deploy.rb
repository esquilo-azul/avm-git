# frozen_string_literal: true

module Avm
  module Git
    module Scms
      class Git < ::Avm::Scms::Base
        class Commit < ::Avm::Scms::Commit
          class Deploy
            include ::Avm::Files::Appendable
            enable_simple_cache

            attr_reader :build_dir, :commit, :target_env, :target_path

            def initialize(commit, target_env, target_path)
              @commit = commit
              @target_env = target_env
              @target_path = target_path
            end

            def run
              fd = ::Avm::Files::Deploy.new(target_env, target_path)
              fd.append_tar_output_command(git_archive_command)
              fd.appended.push(*appended)
              fd.run
            end

            private

            def git_archive_command
              commit.git_repo.command('archive', '--format=tar', commit.id)
            end
          end
        end
      end
    end
  end
end
