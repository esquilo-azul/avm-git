# frozen_string_literal: true

require 'avm/git/auto_commit/rules/base'

module Avm
  module Git
    module AutoCommit
      module Rules
        class Last < ::Avm::Git::AutoCommit::Rules::Base
          class WithFile < ::Avm::Git::AutoCommit::Rules::Base::WithFile
            def commit_info
              file.commits.last.if_present { |v| new_commit_info.fixup(v) }
            end
          end
        end
      end
    end
  end
end
