# frozen_string_literal: true

module Avm
  module Git
    module Scms
      class Git < ::Avm::Scms::Base
        class Interval < ::Avm::Scms::Interval
          def initialize(scm, from, to)
            super
            self.from = scm.commit(from)
            self.to = scm.commit(to)
          end

          # @return [Array<Avm::Git::Scms::Git::Commit>]
          def commits
            scm.git_repo.command('log', '--pretty=format:%H', git_commit_interval).execute!
              .each_line.map { |sha1| scm.commit(sha1.strip) }
          end

          # @return [String]
          def git_commit_interval
            [from.id, to.id].join('..')
          end
        end
      end
    end
  end
end
