# frozen_string_literal: true

require 'avm/result'

module Avm
  module Git
    module Issue
      class Complete
        module LocalTag
          def assert_tag
            if tag_hash
              return if tag_hash == branch_hash

              delete_tag
            end
            create_tag
          end

          def delete_tag
            info 'Removendo tag...'
            git(['tag', '-d', branch_name])
          end

          def tag
            "refs/tags/#{branch_name}"
          end

          def tag_hash
            launcher_git.rev_parse(tag)
          end

          def create_tag
            git(['tag', branch_name, branch_hash])
          end
        end
      end
    end
  end
end
