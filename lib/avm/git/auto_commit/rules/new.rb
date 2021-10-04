# frozen_string_literal: true

require 'avm/git/auto_commit/rules/base'
require 'avm/git/auto_commit_path'

module Avm
  module Git
    module AutoCommit
      module Rules
        class New < ::Avm::Git::AutoCommit::Rules::Base
          class WithFile < ::Avm::Git::AutoCommit::Rules::Base::WithFile
            def auto_commit_path
              ::Avm::Git::AutoCommitPath.new(file.git, file.path)
            end

            def commit_info
              new_commit_info.message(auto_commit_path.commit_message)
            end
          end
        end
      end
    end
  end
end
