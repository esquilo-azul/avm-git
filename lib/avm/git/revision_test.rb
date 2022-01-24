# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'
require 'eac_ruby_utils/ruby'

module Avm
  module Git
    class RevisionTest
      enable_simple_cache
      enable_speaker
      common_constructor :git, :sha1, :options

      def banner
        infov 'Revision to test', sha1
        ::EacRubyUtils::Speaker.context.on(::EacCli::Speaker.new(err_line_prefix: '  ')) do
          revision_banner
        end
      end

      def successful_label
        successful?.to_s.send((successful? ? :green : :red))
      end

      def to_s
        sha1
      end

      def successful?
        successful
      end

      private

      def checkout_revision
        infom 'Checking out revision...'
        git.execute!('checkout', sha1)
      end

      def commit_uncached
        ::Avm::Git::Commit.new(git, sha1)
      end

      def git_absolute_path
        ::File.expand_path(git.to_s)
      end

      def revision_banner
        infov '* Subject', commit.subject
        infov '* Success?', successful_label
        infov '* STDOUT', stdout_cache.content_path
        infov '* STDERR', stderr_cache.content_path
      end

      def root_cache
        fs_cache.child(git_absolute_path.parameterize, sha1,
                       options.fetch(:test_command).to_s.parameterize)
      end

      def run_test
        infom "Running test command \"#{::Shellwords.join(test_command_args)}\"" \
          " on \"#{git_absolute_path}\"..."
        result = ::EacRubyUtils::Ruby.on_clean_environment { test_command.execute }
        infom 'Test done'
        write_result_cache(result)
      end

      def stdout_cache
        root_cache.child('stdout')
      end

      def stderr_cache
        root_cache.child('stderr')
      end

      def successful_cache
        root_cache.child('successful')
      end

      def successful_uncached
        if options.fetch(:no_cache) || !successful_cache.stored?
          checkout_revision
          run_test
        end
        successful_cache.read == 'true'
      end

      def test_command
        ::EacRubyUtils::Envs.local.command(*test_command_args).chdir(git.to_s)
      end

      def test_command_args
        r = ::Shellwords.split(options.fetch(:test_command).to_s)
        return r if r.any?

        raise 'No command found'
      end

      def write_result_cache(result)
        stdout_cache.write(result[:stdout])
        stderr_cache.write(result[:stderr])
        successful_cache.write(result[:exit_code].zero? ? 'true' : 'false')
      end
    end
  end
end
