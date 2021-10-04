# frozen_string_literal: true

require 'eac_ruby_utils/core_ext'

module Avm
  module Git
    class SubrepoCheck
      module ShowResult
        def show_result
          out(subrepo.subpath.to_path.cyan)
          out_attr('parent', parent_result.label)
          run_fix_parent
          out_attr('remote', remote_result.label)
          out("\n")
        end

        def run_fix_parent
          return unless fix_parent?
          return unless parent_result.error?

          out('|Fixing...'.white)
          self.parent_hash = expected_parent_hash
          out_attr('new parent', parent_result.label)
        end

        def out_attr(key, value)
          out('|' + "#{key}=".white + value)
        end
      end
    end
  end
end
