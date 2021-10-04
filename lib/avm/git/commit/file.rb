# frozen_string_literal: true

require 'active_support/core_ext/module/delegation'
require 'eac_ruby_utils/simple_cache'
require 'avm/git/commit/diff_tree_line'

module Avm
  module Git
    class Commit
      class File
        include ::EacRubyUtils::SimpleCache

        attr_reader :git, :diff_tree

        # git: [EacGit::Local]
        # diff_tree_tree: a line of command "git diff-tree --no-commit-id -r --full-index"'s output
        def initialize(git, diff_tree_line)
          @git = git
          @diff_tree = ::Avm::Git::Commit::DiffTreeLine.new(diff_tree_line)
        end

        delegate(*::Avm::Git::Commit::DiffTreeLine::FIELDS, to: :diff_tree)

        def to_s
          "#{path}|#{status}"
        end

        def src_size_uncached
          size(src_sha1)
        end

        def dst_size_uncached
          size(dst_sha1)
        end

        private

        def size(sha1)
          return 0 if /\A0+\z/.match(sha1)

          git.command('cat-file', '-s', sha1).execute!.strip.to_i
        end
      end
    end
  end
end
