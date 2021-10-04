# frozen_string_literal: true

module Avm
  module Git
    class Commit
      class DiffTreeLine
        DIFF_TREE_PATTERN = /\A:(\d{6}) (\d{6}) (\S+) (\S+) (\S+)\t(\S.*)\z/.freeze
        FIELDS = %w[src_mode dst_mode src_sha1 dst_sha1 status path].freeze
        GIT_COMMAND_ARGS = %w[-c core.quotepath=off diff-tree --no-commit-id -r --full-index].freeze

        attr_reader(*FIELDS)

        # line: a line of command "git [GIT_COMMAND_ARGS]"'s output.
        # Reference: https://git-scm.com/docs/git-diff-tree
        def initialize(line)
          m = DIFF_TREE_PATTERN.match(line.strip)
          raise "\"#{line}\" did not match pattern" unless m

          FIELDS.count.times { |i| send("#{FIELDS[i]}=", m[i + 1]) }
        end

        def fields
          FIELDS.map { |field| [field, send(field)] }.to_h
        end

        private

        attr_writer(*FIELDS)
      end
    end
  end
end
