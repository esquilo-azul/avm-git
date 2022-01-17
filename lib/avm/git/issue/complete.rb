# frozen_string_literal: true

require 'avm/tools/core_ext'
require 'eac_git/local'

module Avm
  module Git
    module Issue
      class Complete
        require_sub __FILE__, include_modules: true
        enable_simple_cache
        enable_speaker

        BRANCH_NAME_ISSUE_ID_PATTERN =

          attr_reader :dir, :skip_validations

        def initialize(options)
          consumer = ::EacRubyUtils::OptionsConsumer.new(options)
          @dir, @skip_validations = consumer.consume_all(:dir, :skip_validations)
          validate_skip_validations
          consumer.validate
        end

        def start_banner
          validations_banner
        end

        def run
          return false unless valid?

          assert_tag
          push
          remove_local_branch
          clipboard_copy_tracker_message
          true
        end

        def issue_id
          branch ? issue_id_parser.parse(branch_name) : nil
        end

        # @return [EacRubyUtils::RegexpParser]
        def issue_id_parser
          /\A#{Regexp.quote('issue_')}(\d+)\z/.to_parser { |m| m[1].to_i }
        end

        private

        # @return [EacGit::Local]
        def eac_git_uncached
          ::EacGit::Local.new(dir)
        end

        def git_execute(args, exit_outputs = {})
          r = launcher_git.execute!(args, exit_outputs: exit_outputs)
          r.is_a?(String) ? r.strip : r
        end

        def launcher_git_uncached
          ::Avm::Launcher::Git::Base.new(dir)
        end
      end
    end
  end
end
