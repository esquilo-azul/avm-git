# frozen_string_literal: true

require 'avm/git/auto_commit/rules/base'

module Avm
  module Git
    module AutoCommit
      module Rules
        class Nth < ::Avm::Git::AutoCommit::Rules::Base
          SHORT_KEY = 't'

          class << self
            def short_key
              SHORT_KEY
            end
          end

          common_constructor :number do
            self.number = number.to_i
          end

          class WithFile < ::Avm::Git::AutoCommit::Rules::Base::WithFile
            def commit_info
              file.commits(number - 1).if_present { |v| new_commit_info.fixup(v) }
            end
          end
        end
      end
    end
  end
end
