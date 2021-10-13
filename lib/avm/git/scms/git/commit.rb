# frozen_string_literal: true

require 'avm/scms/commit'
require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module Scms
      class Git < ::Avm::Scms::Base
        class Commit < ::Avm::Scms::Commit
          common_constructor :git_scm, :git_commit do
            git_commit.assert_argument(::EacGit::Local::Commit, 'git_commit')
          end
          delegate :git_repo, to: :git_scm

          # @return [Array<Pathname>]
          def changed_files
            git_commit.changed_files.map { |cf| cf.path.to_pathname }
          end

          # @param other [Avm::Git::Scms::Git::Commit]
          # @return [Avm::Git::Scms::Git::Commit]
          def merge_with(other)
            validate_clean_and_head
            raise 'Implemented for only if other is parent' unless
            other.git_commit == git_commit.parent

            git_scm.reset_and_commit(other.git_commit.parent, other.git_commit.raw_body)
          end

          def reword(new_message)
            validate_clean_and_head

            git_repo.command('commit', '--amend', '-m', new_message).execute!
            self.class.new(git_scm, git_repo.head)
          end

          # @param path [Pathname]
          # @return [TrueClass,FalseClass]
          def scm_file?(path)
            %w[.gitrepo .gitmodules].any? { |file| file.include?(path.basename.to_path) }
          end

          private

          def validate_clean_and_head
            raise 'Implemented for only if repository is no dirty' if git_repo.dirty?
            raise 'Implemented for only if self is HEAD' unless
            git_commit == git_repo.head
          end
        end
      end
    end
  end
end
