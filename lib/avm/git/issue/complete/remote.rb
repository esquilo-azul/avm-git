# frozen_string_literal: true

module Avm
  module Git
    module Issue
      class Complete
        module Remote
          def remote_master_hash
            remote_hashs['refs/heads/master']
          end

          def remote_branch_hash
            remote_hashs["refs/heads/#{branch}"]
          end

          def remote_tag_hash
            remote_hashs[tag]
          end

          private

          def remote_name
            'origin'
          end

          def remote_hashs_uncached
            @git.remote_hashs(remote_name)
          end
        end
      end
    end
  end
end
