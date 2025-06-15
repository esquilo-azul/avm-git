# frozen_string_literal: true

module Avm
  module Git
    module Runners
      class Base
        class RevisionsTest
          runner_with :help do
            desc 'Test multiple revisions until a error is found.'
            arg_opt '-c', '--command', 'Command to test instance.'
            bool_opt '-n', '--no-cache', 'Does not use cache.'
          end

          def run
            fatal_error('Repository is dirty') if runner_context.call(:git).dirty?

            return_to_branch_on_end do
              infov 'Revisions found', revisions.count
              if revision_with_error
                warn("First revision with error: #{revision_with_error}")
              else
                success('No error found in revisions')
              end
            end
          end

          private

          def return_to_branch_on_end
            current_branch = runner_context.call(:git).current_branch
            yield
          ensure
            infom "Returning to original branch \"#{current_branch}\""
            runner_context.call(:git).execute!('checkout', current_branch)
          end

          def revision_with_error_uncached
            revision_with_error = nil
            revisions.each do |revision|
              revision.banner
              unless revision.successful?
                revision_with_error = revision
                break
              end
            end
            revision_with_error
          end

          def revisions_uncached
            runner_context.call(:git).execute!('log', '--pretty=format:%H', 'origin/master..HEAD')
              .each_line.map(&:strip).reverse.map do |sha1|
              ::Avm::Git::RevisionTest.new(runner_context.call(:git), sha1, test_revision_options)
            end
          end

          def test_revision_options
            { test_command: parsed.command, no_cache: parsed.no_cache? }
          end
        end
      end
    end
  end
end
