# frozen_string_literal: true

require 'avm/scms/commit'
require 'eac_ruby_utils'

module Avm
  module Git
    module Scms
      class Git < ::Avm::Scms::Base
        module Milestones
          BASE_COMMIT_REFERENCE = 'origin/master'

          # @return [Avm::Git::Scms::Git::Commit]
          def current_milestone_base_commit
            commit(BASE_COMMIT_REFERENCE)
          end
        end
      end
    end
  end
end
