# frozen_string_literal: true

require 'avm/git/auto_commit/commit_info'
require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    class FileAutoFixup
      enable_speaker
      enable_simple_cache
      enable_listable

      common_constructor :git, :path, :rules do
        self.path = path.to_pathname.expand_path(git.root_path)
      end

      COMMITS_SEARCH_INTERVAL = 'origin/master..HEAD'

      def git_relative_path
        path.to_pathname.relative_path_from(git.root_path)
      end

      def run
        start_banner
        run_commit || warn("No rule returned commit information for \"#{path}\"")
      end

      private

      def commit_args
        commit_info.if_present([], &:git_commit_args) + ['--', git_relative_path]
      end

      def commit_info_uncached
        rules.lazy.map { |rule| rule.with_file(self).commit_info }.find(&:present?)
      end

      def start_banner
        infov 'Path', path
        infov '  Commits found', commits.count
      end

      def run_commit
        return false if commit_info.blank?

        infov '  Commit arguments', ::Shellwords.join(commit_args)
        run_git_add_and_commit
        success '  Commited'
        true
      end

      def run_git_add_and_commit
        git.execute!('reset', '--soft', 'HEAD')
        if path.exist?
          git.execute!('add', git_relative_path)
        else
          git.execute!('rm', '-f', git_relative_path)
        end
        git.execute!('commit', *commit_args)
      end

      def commits_uncached
        git.execute!('log', '--pretty=format:%H', COMMITS_SEARCH_INTERVAL, '--', path)
           .each_line.map { |sha1| ::Avm::Git::Commit.new(git, sha1.strip) }
           .reject { |commit| commit.subject.start_with?('fixup!') }
           .each_with_index.map { |commit, index| CommitDelegator.new(commit, index) }
      end

      class CommitDelegator < ::SimpleDelegator
        attr_reader :index

        def initialize(commit, index)
          super(commit)
          @index = index
        end

        def position
          index + 1
        end
      end
    end
  end
end
