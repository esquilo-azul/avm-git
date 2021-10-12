# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module Scms
      class Git < ::Avm::Scms::Base
        class ChangeTracker
          common_constructor :git_scm, :message
          attr_reader :starting_commit
          delegate :git_repo, to: :git_scm

          def start
            raise 'Repository is dirty' if git_repo.dirty?

            self.starting_commit = git_repo.head
          end

          # @return [Avm::Git::Scms::Git::Commit, nil]
          def stop
            git_scm.commit_dirty
            return nil if starting_commit == git_repo.head

            git_scm.reset_and_commit(starting_commit, message)
          end

          private

          attr_writer :starting_commit
        end
      end
    end
  end
end
