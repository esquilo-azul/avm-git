# frozen_string_literal: true

require 'avm/git/auto_commit/rules/base'

module Avm
  module Git
    module AutoCommit
      module Rules
        class Unique < ::Avm::Git::AutoCommit::Rules::Base
          class WithFile < ::Avm::Git::AutoCommit::Rules::Base::WithFile
            def commit_info
              return nil unless file.commits.count == 1

              new_commit_info.fixup(file.commits.first)
            end
          end
        end
      end
    end
  end
end
