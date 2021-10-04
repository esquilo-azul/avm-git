# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module AutoCommit
      module Rules
        class Base
          class << self
            def keys
              [long_key, short_key]
            end

            def long_key
              name.demodulize.variableize
            end

            def short_key
              long_key[0, 1]
            end
          end

          def with_file(file)
            self.class.const_get('WithFile').new(self, file)
          end

          class WithFile
            common_constructor :rule, :file

            def new_commit_info
              ::Avm::Git::AutoCommit::CommitInfo.new
            end
          end
        end
      end
    end
  end
end
