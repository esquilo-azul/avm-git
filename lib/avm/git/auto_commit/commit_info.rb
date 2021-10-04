# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module AutoCommit
      class CommitInfo
        enable_immutable

        immutable_accessor :fixup, :message

        def git_commit_args
          r = fixup.if_present([]) { |v| ['--fixup', v.sha1] }
          r += message.if_present([]) { |v| ['--message', v] }
          return r if r.any?

          raise 'Argument list is empty'
        end
      end
    end
  end
end
