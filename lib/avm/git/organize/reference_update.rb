# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    module Organize
      class ReferenceUpdate
        enable_listable
        lists.add_symbol :operation, :remove

        common_constructor :repository, :reference, :operation

        def run_operation
          send("run_operation_#{operation}")
        end

        def to_s
          "#{reference} [#{operation}]"
        end

        private

        def reference_pathname
          repository.refs_root.join(reference)
        end

        def run_operation_remove
          reference_pathname.unlink
        end
      end
    end
  end
end
