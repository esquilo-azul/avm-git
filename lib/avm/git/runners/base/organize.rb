# frozen_string_literal: true

require 'avm/git/organize/repository'
require 'eac_cli/default_runner'

module Avm
  module Git
    module Runners
      class Base
        class Organize
          runner_with :help do
            desc 'Organize branches.'
            bool_opt '-a', '--all', 'Run all organizations.'
            bool_opt '-n', '--no', 'Do not run operations.'
            bool_opt '-o', '--originals', 'Remove refs/original branches.'
            bool_opt '-s', '--subrepos', 'Remove git-subrepo branches.'
            bool_opt '-y', '--yes', 'Run operations without confirmation.'
          end

          def run
            start_banner
            collect_references
            after_collect_banner
            run_operations
          end

          private

          def after_collect_banner
            infov 'Collected references', repository.collected_references.count
            repository.collected_references.each do |ru|
              infov "  * #{ru.reference}", ru.operation
            end
          end

          def collect?(type)
            parsed.fetch(type) || parsed.all?
          end

          def collect_references
            %w[subrepos originals].each do |type|
              repository.send("collect_#{type}") if collect?(type)
            end
          end

          def run_operations
            return warn('No operations to run (Run with --help to see options)') if
            repository.collected_references.empty?
            return unless run_operations?

            repository.collected_references.each do |ru|
              info "Doing operation #{ru}..."
              ru.run_operation
            end
          end

          def run_operations?
            return true if parsed.yes?
            return false if parsed.no?

            input('Confirm operations?', bool: true)
          end

          def repository_uncached
            ::Avm::Git::Organize::Repository.new(runner_context.call(:git).eac_git)
          end

          def start_banner
            infov 'Repository', repository
          end
        end
      end
    end
  end
end
