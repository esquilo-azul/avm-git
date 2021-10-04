# frozen_string_literal: true

require 'avm/tools/core_ext'
require 'clipboard'

module Avm
  module Git
    module Issue
      class Deliver
        enable_simple_cache
        enable_speaker

        common_constructor :git_repo

        def run
          push
          clipboard_copy_tracker_message
          true
        end

        def start_banner
          infov 'Branch name', branch_name
          infov 'Commit ID', branch_commit_id
          infov 'Push arguments', ::Shellwords.join(push_args)
        end

        private

        def branch_commit_id
          git_repo.rev_parse(branch_name)
        end

        def branch_name_uncached
          git_repo.command('rev-parse', '--abbrev-ref', 'HEAD').execute!.strip
        end

        def clipboard_copy_tracker_message
          ::Clipboard.copy(textile_tracker_message)
          infov 'Copied to clipboard', textile_tracker_message
        end

        def push
          git_repo.command(*push_args).system!
        end

        def push_args
          %w[push origin --force] + ["#{branch_name}:refs/heads/#{branch_name}"]
        end

        def textile_tracker_message
          "#{branch_name}: commit:#{branch_commit_id}."
        end
      end
    end
  end
end
