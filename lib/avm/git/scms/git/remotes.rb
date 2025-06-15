# frozen_string_literal: true

module Avm
  module Git
    module Scms
      class Git < ::Avm::Scms::Base
        module Remotes
          DEFAULT_REMOTE_ID = 'origin'

          # @return [Avm::Git::Scms::Git::Remote]
          def default_remote
            remote(default_remote_id)
          end

          # @return [String]
          def default_remote_id
            DEFAULT_REMOTE_ID
          end

          # @param id [String]
          # @return [Avm::Git::Scms::Git::Remote]
          def remote(id)
            ::Avm::Git::Scms::Git::Remote.new(self, git_repo.remote(id))
          end
        end
      end
    end
  end
end
