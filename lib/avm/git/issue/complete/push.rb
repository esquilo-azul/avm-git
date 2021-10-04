# frozen_string_literal: true

module Avm
  module Git
    module Issue
      class Complete
        module Push
          def dry_push_args
            %w[push --dry-run] + [remote_name] + pushs
          end

          def dry_push_result
            return ::Avm::Result.error('Nothing to push') if pushs.empty?

            r = @git.execute(dry_push_args)
            message = if r.fetch(:exit_code).zero?
                        'ok'
                      else
                        r.fetch(:stderr) + "\n#{::Shellwords.join(dry_push_args)}"
                      end
            ::Avm::Result.success_or_error(r.fetch(:exit_code).zero?, message)
          end

          def push
            if pushs.empty?
              info 'PUSH: Nada a enviar'
            else
              info "PUSH: enviando \"#{pushs}\"..."
              git(%w[push origin] + pushs)
            end
          end

          def pushs_uncached
            [master_push, remove_branch_push, tag_push].reject(&:nil?)
          end

          def master_push
            remote_master_hash != branch_hash ? "#{branch_hash}:refs/heads/master" : nil
          end

          def remove_branch_push
            remote_branch_hash ? ":refs/heads/#{branch}" : nil
          end

          def tag_push
            return nil unless !remote_tag_hash || remote_tag_hash != branch_hash

            "#{branch_hash}:#{tag}"
          end
        end
      end
    end
  end
end
