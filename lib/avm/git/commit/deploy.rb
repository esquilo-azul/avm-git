# frozen_string_literal: true

require 'addressable'
require 'eac_ruby_utils/core_ext'
require 'avm/files/appendable'
require 'avm/files/deploy'

module Avm
  module Git
    class Commit
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
          commit.git.command('archive', '--format=tar', commit.sha1)
        end
      end
    end
  end
end
